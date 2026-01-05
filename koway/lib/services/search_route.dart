import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<String>> searchRoutes(String origin, String destination) async {
  try {
    final String response = await rootBundle.loadString('assets/hashed_routes.json');
    final Map<String, dynamic> routeIndex = json.decode(response);

    if(!routeIndex.containsKey(origin) || !routeIndex.containsKey(destination)){
      return [];
    }

    List<String> originRoutes = routeIndex[origin];
    List<String> destRoutes = routeIndex[destination];

    List<String> foundRoutes = [];

    for(var route in originRoutes){
      if(destRoutes.contains(route)){
        foundRoutes.add(route);
      }
    }

    return foundRoutes;

  } catch (e) {
    throw Exception("Error loading routes: $e");
  }
}
