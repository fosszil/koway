import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/bus_routes.dart';

Future<List<BusRoute>> fetchRoutes() async {
  // Load the JSON string from the asset file
  final String response = await rootBundle.loadString('assets/routes.json');
  
  // Decode the JSON string into a Dart List of dynamic objects
  final List<dynamic> data = json.decode(response);

  // Map the list of dynamic objects to a List<BusRoute>
  // and return it.
  return data.map((json) => BusRoute.fromJson(json)).toList();
}