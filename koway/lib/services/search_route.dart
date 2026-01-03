import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';

Future<List<BusRoute>> searchRoutes(String origin, String destination) async {
  try {
    final String response = await rootBundle.loadString('assets/hashed_routes.json');
    final Map<String, dynamic> decoded = json.decode(response);

    final List<dynamic> routeIndex = decoded["routes"] ?? [];

    return routeIndex
        .map((e) => BusRoute.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } catch (e) {
    throw Exception("Error loading routes: $e");
  }
}
