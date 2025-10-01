// dependencies.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/activity/activity_repository.dart';
import '../data/repositories/activity/activity_repository_local.dart';
import '../data/repositories/activity/activity_repository_remote.dart';
import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_dev.dart';
import '../data/repositories/auth/auth_repository_remote.dart';
import '../data/repositories/booking/booking_repository.dart';
import '../data/repositories/booking/booking_repository_local.dart';
import '../data/repositories/booking/booking_repository_remote.dart';
import '../data/repositories/continent/continent_repository.dart';
import '../data/repositories/continent/continent_repository_local.dart';
import '../data/repositories/continent/continent_repository_remote.dart';
import '../data/repositories/destination/destination_repository.dart';
import '../data/repositories/destination/destination_repository_local.dart';
import '../data/repositories/destination/destination_repository_remote.dart';
import '../data/repositories/itinerary_config/itinerary_config_repository.dart';
import '../data/repositories/itinerary_config/itinerary_config_repository_memory.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/repositories/user/user_repository_local.dart';
import '../data/repositories/user/user_repository_remote.dart';
import '../data/services/api/api_client.dart';
import '../data/services/api/auth_api_client.dart';
import '../data/services/local/local_data_service.dart';
import '../data/services/shared_preferences_service.dart';
import '../domain/use_cases/booking/booking_create_use_case.dart';
import '../domain/use_cases/booking/booking_share_use_case.dart';

/// Shared providers
final List<SingleChildWidget> _sharedProviders = [
  Provider<BookingCreateUseCase>(
    create: (context) => BookingCreateUseCase(
      destinationRepository: context.read<DestinationRepository>(),
      activityRepository: context.read<ActivityRepository>(),
      bookingRepository: context.read<BookingRepository>(),
    ),
  ),
  Provider<BookingShareUseCase>(
    create: (context) => BookingShareUseCase.withSharePlus(),
  ),
];

/// Remote dependencies
List<SingleChildWidget> get providersRemote => [
      Provider<AuthApiClient>(create: (_) => AuthApiClient()),
      Provider<ApiClient>(create: (_) => ApiClient()),
      Provider<SharedPreferencesService>(create: (_) => SharedPreferencesService()),
      ChangeNotifierProvider<AuthRepository>(
        create: (context) => AuthRepositoryRemote(
          authApiClient: context.read<AuthApiClient>(),
          apiClient: context.read<ApiClient>(),
          sharedPreferencesService: context.read<SharedPreferencesService>(),
        ),
      ),
      Provider<DestinationRepository>(
        create: (context) => DestinationRepositoryRemote(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<ContinentRepository>(
        create: (context) => ContinentRepositoryRemote(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<ActivityRepository>(
        create: (context) => ActivityRepositoryRemote(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<ItineraryConfigRepository>(
        create: (_) => ItineraryConfigRepositoryMemory(),
      ),
      Provider<BookingRepository>(
        create: (context) => BookingRepositoryRemote(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      Provider<UserRepository>(
        create: (context) => UserRepositoryRemote(
          apiClient: context.read<ApiClient>(),
        ),
      ),
      ..._sharedProviders,
    ];

/// Local dependencies
List<SingleChildWidget> get providersLocal => [
      ChangeNotifierProvider<AuthRepository>.value(value: AuthRepositoryDev()),
      Provider<LocalDataService>.value(value: LocalDataService()),
      Provider<DestinationRepository>(
        create: (context) => DestinationRepositoryLocal(
          localDataService: context.read<LocalDataService>(),
        ),
      ),
      Provider<ContinentRepository>(
        create: (context) => ContinentRepositoryLocal(
          localDataService: context.read<LocalDataService>(),
        ),
      ),
      Provider<ActivityRepository>(
        create: (context) => ActivityRepositoryLocal(
          localDataService: context.read<LocalDataService>(),
        ),
      ),
      Provider<BookingRepository>(
        create: (context) => BookingRepositoryLocal(
          localDataService: context.read<LocalDataService>(),
        ),
      ),
      Provider<ItineraryConfigRepository>(
        create: (_) => ItineraryConfigRepositoryMemory(),
      ),
      Provider<UserRepository>(
        create: (context) => UserRepositoryLocal(
          localDataService: context.read<LocalDataService>(),
        ),
      ),
      ..._sharedProviders,
    ];
