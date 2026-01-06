import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';

class RouteService {
  static final RouteService instance = RouteService._init();
  RouteService._init();

  List<BusRoute> _allRoutes = [];
  Map<String, dynamic> _searchIndex = {};

  Future<List<BusRoute>> fetchAllRoutes() async {
    //Caching
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
      log("❌ Error loading routes: $e");
      return [];
    }
  }


  Future<void> loadSearchIndex() async {
    if (_searchIndex.isNotEmpty) return;

    try {
      final String response = await rootBundle.loadString('assets/hashed_routes.json');
      _searchIndex = json.decode(response);
    } catch (e) {
      print("❌ Error loading search index: $e");
    }
  }

  List<String> get allStops {
    var stops = _searchIndex.keys.toList();
    stops.sort(); 
    return stops;
  }

  List<String> findRoutesBetween(String origin, String dest) {
    if (_searchIndex.isEmpty) {
      log("⚠️ Warning: Search index not loaded.");
      return [];
    }
    if (!_searchIndex.containsKey(origin) || !_searchIndex.containsKey(dest)) {
      return [];
    }

    List<String> originRoutes = List<String>.from(_searchIndex[origin]);
    List<String> destRoutes = List<String>.from(_searchIndex[dest]);

    List<String> commonRoutes = [];

    for (var route in originRoutes) {
      if (destRoutes.contains(route)) {
        commonRoutes.add(route);
      }
    }
    
    return commonRoutes;
  }
}