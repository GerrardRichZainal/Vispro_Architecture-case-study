import 'package:logging/logging.dart';
import '../../../utils/result.dart';
import '../../services/api/api_client.dart';
import '../../services/api/auth_api_client.dart';
import '../../services/api/model/login_request/login_request.dart';
import '../../services/api/model/login_response/login_response.dart';
import '../../services/shared_preferences_service.dart';
import 'auth_repository.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiClient = apiClient,
        _authApiClient = authApiClient,
        _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authHeaderProvider = _authHeaderProvider;
  }

  final AuthApiClient _authApiClient;
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  /// Fetch token from shared preferences
  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();
    if (result is Ok<String?>) {
      _authToken = result.value;
      _isAuthenticated = result.value != null;
    } else if (result is Error<String?>) {
      _log.severe(
        'Failed to fetch Token from SharedPreferences',
        result.error,
      );
    }
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) return _isAuthenticated!;
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiClient.login(
        LoginRequest(email: email, password: password),
      );

      if (result is Ok<LoginResponse>) {
        _log.info('User logged in');
        _isAuthenticated = true;
        _authToken = result.value.token;
        // Store token
        return await _sharedPreferencesService.saveToken(result.value.token);
      } else if (result is Error<LoginResponse>) {
        _log.warning('Error logging in: ${result.error}');
        return Result.error(result.error);
      } else {
        return Result.error(Exception('Unknown login error'));
      }

    } finally {
      notifyListeners();
    }
  }

  @override
  Future<Result<void>> logout() async {
    _log.info('User logged out');
    try {
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Error<void>) {
        _log.severe('Failed to clear stored auth token');
      }
      _authToken = null;
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}
