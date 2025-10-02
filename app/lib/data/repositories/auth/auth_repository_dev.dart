import '../../../utils/result.dart';
import 'auth_repository.dart';

class AuthRepositoryDev extends AuthRepository {
  bool _isAuthenticated = false;

  @override
  Future<bool> get isAuthenticated => Future.value(_isAuthenticated);

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    _isAuthenticated = true;
    notifyListeners();
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> logout() async {
    _isAuthenticated = false;
    notifyListeners();
    return const Result.ok(null);
  }
}