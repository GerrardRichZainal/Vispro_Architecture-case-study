import 'dart:convert';
import 'package:flutter/services.dart';

import '../../../config/assets.dart';
import '../../../domain/models/activity/activity.dart';
import '../../../domain/models/continent/continent.dart';
import '../../../domain/models/destination/destination.dart';
import '../../../domain/models/user/user.dart';

class LocalDataService {
  List<Continent> getContinents() {
    return [
      const Continent(
        name: 'Europe',
        imageUrl: 'https://rstr.in/google/tripedia/TmR12QdlVTT',
      ),
      const Continent(
        name: 'Asia',
        imageUrl: 'https://rstr.in/google/tripedia/VJ8BXlQg8O1',
      ),
      const Continent(
        name: 'South America',
        imageUrl: 'https://rstr.in/google/tripedia/flm_-o1aI8e',
      ),
      const Continent(
        name: 'Africa',
        imageUrl: 'https://rstr.in/google/tripedia/-nzi8yFOBpF',
      ),
      const Continent(
        name: 'North America',
        imageUrl: 'https://rstr.in/google/tripedia/jlbgFDrSUVE',
      ),
      const Continent(
        name: 'Oceania',
        imageUrl: 'https://rstr.in/google/tripedia/vxyrDE-fZVL',
      ),
      const Continent(
        name: 'Australia',
        imageUrl: 'https://rstr.in/google/tripedia/z6vy6HeRyvZ',
      ),
    ];
  }

  Future<List<Activity>> getActivities() async {
    final json = await _loadStringAsset(Assets.activities);
    return json.map<Activity>((e) => Activity.fromJson(e)).toList();
  }

  Future<List<Destination>> getDestinations() async {
    final json = await _loadStringAsset(Assets.destinations);
    return json.map<Destination>((e) => Destination.fromJson(e)).toList();
  }

  Future<List<Map<String, dynamic>>> _loadStringAsset(String asset) async {
    final localData = await rootBundle.loadString(asset);
    return (jsonDecode(localData) as List).cast<Map<String, dynamic>>();
  }

  User getUser() {
    return const User(
      name: 'Sofie',
      picture: 'assets/user.jpg',
    );
  }
}
