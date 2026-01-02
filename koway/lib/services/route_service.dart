import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';

Future<List<BusRoute>> fetchRoutes() async {
  try {
    final String response = await rootBundle.loadString('assets/routes.json');
    final Map<String, dynamic> decoded = json.decode(response);

    final List<dynamic> routesList = decoded["routes"] ?? [];

    return routesList
        .map((e) => BusRoute.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  } catch (e, stacktrace) {
    print("❌ Error loading routes: $e");
    print(stacktrace);
    throw Exception("Error loading routes: $e");
  }
}
