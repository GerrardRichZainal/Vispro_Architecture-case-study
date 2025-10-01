import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/booking/booking_repository.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/repositories/destination/destination_repository.dart';
import '../data/repositories/activity/activity_repository.dart';
import '../data/repositories/continent/continent_repository.dart';
import '../data/repositories/itinerary_config/itinerary_config_repository.dart';

import '../ui/auth/login/view_models/login_viewmodel.dart';
import '../ui/auth/login/widgets/login_screen.dart';
import '../ui/home/view_models/home_viewmodel.dart';
import '../ui/home/widgets/home_screen.dart';
import '../ui/search_form/view_models/search_form_viewmodel.dart';
import '../ui/search_form/widgets/search_form_screen.dart';
import '../ui/results/view_models/results_viewmodel.dart';
import '../ui/results/widgets/results_screen.dart';
import '../ui/activities/view_models/activities_viewmodel.dart';
import '../ui/activities/widgets/activities_screen.dart';
import '../ui/booking/view_models/booking_viewmodel.dart';
import '../ui/booking/widgets/booking_screen.dart';
import '../domain/use_cases/booking/booking_create_use_case.dart';
import '../domain/use_cases/booking/booking_share_use_case.dart';
import 'routes.dart';

GoRouter router(AuthRepository authRepository) => GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      refreshListenable: authRepository,
      redirect: (context, state) async {
        final loggedIn = await authRepository.isAuthenticated;
        final loggingIn = state.matchedLocation == Routes.login;
        if (!loggedIn) return Routes.login;
        if (loggingIn) return Routes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.login,
          builder: (context, state) => LoginScreen(
            viewModel: LoginViewModel(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ),
        GoRoute(
          path: Routes.home,
          builder: (context, state) => HomeScreen(
            viewModel: HomeViewModel(
              bookingRepository: context.read<BookingRepository>(),
              userRepository: context.read<UserRepository>(),
            ),
          ),
          routes: [
            GoRoute(
              path: Routes.searchRelative,
              builder: (context, state) => SearchFormScreen(
                viewModel: SearchFormViewModel(
                  continentRepository: context.read<ContinentRepository>(),
                  itineraryConfigRepository:
                      context.read<ItineraryConfigRepository>(),
                ),
              ),
            ),
            GoRoute(
              path: Routes.resultsRelative,
              builder: (context, state) => ResultsScreen(
                viewModel: ResultsViewModel(
                  destinationRepository: context.read<DestinationRepository>(),
                  itineraryConfigRepository:
                      context.read<ItineraryConfigRepository>(),
                ),
              ),
            ),
            GoRoute(
              path: Routes.activitiesRelative,
              builder: (context, state) => ActivitiesScreen(
                viewModel: ActivitiesViewModel(
                  activityRepository: context.read<ActivityRepository>(),
                  itineraryConfigRepository:
                      context.read<ItineraryConfigRepository>(),
                ),
              ),
            ),
            GoRoute(
              path: Routes.bookingRelative,
              builder: (context, state) {
                final viewModel = BookingViewModel(
                  itineraryConfigRepository:
                      context.read<ItineraryConfigRepository>(),
                  createBookingUseCase: context.read<BookingCreateUseCase>(),
                  shareBookingUseCase: context.read<BookingShareUseCase>(),
                  bookingRepository: context.read<BookingRepository>(),
                );

                WidgetsBinding.instance.addPostFrameCallback(
                    (_) => viewModel.createBooking.execute());

                return BookingScreen(viewModel: viewModel);
              },
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) {
                    final id = int.parse(state.pathParameters['id']!);
                    final viewModel = BookingViewModel(
                      itineraryConfigRepository:
                          context.read<ItineraryConfigRepository>(),
                      createBookingUseCase:
                          context.read<BookingCreateUseCase>(),
                      shareBookingUseCase: context.read<BookingShareUseCase>(),
                      bookingRepository: context.read<BookingRepository>(),
                    );

                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => viewModel.loadBooking.execute(id));

                    return BookingScreen(viewModel: viewModel);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
