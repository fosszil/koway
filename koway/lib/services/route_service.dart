import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';

Future<List<BusRoute>> fetchRoutes() async {
  try {
    final String response = await rootBundle.loadString('assets/routes.json');
    final Map<String, dynamic> decoded = json.decode(response);

    // Extract the list under "routes"
    final List<dynamic> routesList = decoded["routes"] ?? [];

    // Convert each route entry to a BusRoute object
    return routesList
        .map((e) => BusRoute.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } catch (e, stacktrace) {
    print("❌ Error loading routes: $e");
    print(stacktrace);
    throw Exception("Error loading routes: $e");
  }
}
