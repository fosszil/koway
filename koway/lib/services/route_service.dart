import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';

class RouteService {
  static final RouteService instance = RouteService._init();
  RouteService._init();

  List<BusRoute> _allRoutes = []; 

  Map<String, List<String>> _searchIndex = {};

  Future<List<BusRoute>> fetchAllRoutes() async {
    await loadSearchIndex();

    if (_allRoutes.isNotEmpty) return _allRoutes;

    try {
      final String response = await rootBundle.loadString('assets/routes.json');
      final Map<String, dynamic> decoded = json.decode(response);

      final List<dynamic> routesList = decoded["routes"] ?? [];

      _allRoutes = routesList
          .map((e) => BusRoute.fromJson(Map<String, dynamic>.from(e)))
          .toList();

      return _allRoutes;
    } catch (e) {
      log("Error loading routes: $e");
      return [];
    }
  }

  Future<void> loadSearchIndex() async {
    if (_searchIndex.isNotEmpty) return;

    try {
      final String response = await rootBundle.loadString(
        'assets/hashed_routes.json',
      );
      final dynamic decoded = json.decode(response);

      if (decoded is Map<String, dynamic>) {
        _searchIndex = {};
        decoded.forEach((key, value) {
          if (value is List) {
            _searchIndex[key] = List<String>.from(
              value.map((e) => e.toString()),
            );
          }
        });
        print("Search index loaded. Total stops: ${_searchIndex.length}");
      }
    } catch (e) {
      print("rror loading search index: $e");
    }
  }

  List<String> get allStops {
    var stops = _searchIndex.keys.toList();
    stops.sort();
    return stops;
  }

  List<String> findRoutesBetween(String originInput, String destInput) {
    if (_searchIndex.isEmpty) {
      print("Search index is empty");
      return [];
    }

    String? findKeyIgnoringCase(String input) {
      String cleanInput = input.trim().toLowerCase();
      try {
        return _searchIndex.keys.firstWhere((key) {
          return key.trim().toLowerCase() == cleanInput;
        });
      } catch (e) {
        return null;
      }
    }

    String? originKey = findKeyIgnoringCase(originInput);
    String? destKey = findKeyIgnoringCase(destInput);

    if (originKey == null) {
      print("'$originInput' not found in database.");
      return [];
    }
    if (destKey == null) {
      print("Destination '$destInput' not found in database.");
      return [];
    }

    print("Found keys: '$originKey' and '$destKey'");

    Set<String> originBuses = _searchIndex[originKey]!.toSet();
    List<String> destBuses = _searchIndex[destKey]!;

    List<String> commonRoutes = destBuses
        .where((busId) => originBuses.contains(busId))
        .toList();

    return commonRoutes;
  }
}
