// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:logging/logging.dart';

import '../../../data/repositories/activity/activity_repository.dart';
import '../../../data/repositories/booking/booking_repository.dart';
import '../../../data/repositories/destination/destination_repository.dart';
import '../../../utils/result.dart';
import '../../models/activity/activity.dart';
import '../../models/booking/booking.dart';
import '../../models/destination/destination.dart';
import '../../models/itinerary_config/itinerary_config.dart';

/// UseCase for creating [Booking] objects from [ItineraryConfig].
class BookingCreateUseCase {
  BookingCreateUseCase({
    required DestinationRepository destinationRepository,
    required ActivityRepository activityRepository,
    required BookingRepository bookingRepository,
  })  : _destinationRepository = destinationRepository,
        _activityRepository = activityRepository,
        _bookingRepository = bookingRepository;

  final DestinationRepository _destinationRepository;
  final ActivityRepository _activityRepository;
  final BookingRepository _bookingRepository;
  final _log = Logger('BookingCreateUseCase');

  /// Create [Booking] from a stored [ItineraryConfig]
  Future<Result<Booking>> createFrom(ItineraryConfig itineraryConfig) async {
    // Check destination
    if (itineraryConfig.destination == null) {
      _log.warning('Destination is not set');
      return Result.error(Exception('Destination is not set'));
    }

    final destinationResult = await _fetchDestination(itineraryConfig.destination!);
    if (destinationResult is Error<Destination>) {
      _log.warning('Error fetching destination: ${destinationResult.error}');
      return Result.error(destinationResult.error);
    }
    final destination = (destinationResult as Ok<Destination>).value;
    _log.fine('Destination loaded: ${destination.ref}');

    // Check activities
    if (itineraryConfig.activities.isEmpty) {
      _log.warning('Activities are not set');
      return Result.error(Exception('Activities are not set'));
    }

    final activitiesResult = await _activityRepository.getByDestination(itineraryConfig.destination!);
    if (activitiesResult is Error<List<Activity>>) {
      _log.warning('Error fetching activities: ${activitiesResult.error}');
      return Result.error(activitiesResult.error);
    }
    final activities = (activitiesResult as Ok<List<Activity>>).value
        .where((activity) => itineraryConfig.activities.contains(activity.ref))
        .toList();
    _log.fine('Activities loaded (${activities.length})');

    // Check dates
    if (itineraryConfig.startDate == null || itineraryConfig.endDate == null) {
      _log.warning('Dates are not set');
      return Result.error(Exception('Dates are not set'));
    }

    final booking = Booking(
      startDate: itineraryConfig.startDate!,
      endDate: itineraryConfig.endDate!,
      destination: destination,
      activity: activities,
    );

    // Save booking
    final saveBookingResult = await _bookingRepository.createBooking(booking);
    if (saveBookingResult is Error<void>) {
      _log.warning('Failed to save booking', saveBookingResult.error);
      return Result.error(saveBookingResult.error);
    }
    _log.fine('Booking saved successfully');

    return Result.ok(booking);
  }

  Future<Result<Destination>> _fetchDestination(String destinationRef) async {
    final result = await _destinationRepository.getDestinations();
    if (result is Error<List<Destination>>) {
      return Result.error(result.error);
    }

    try {
      final destination = (result as Ok<List<Destination>>)
          .value
          .firstWhere((d) => d.ref == destinationRef);
      return Result.ok(destination);
    } catch (e) {
      return Result.error(Exception('Destination not found'));
    }
  }
}
