//import 'dart:convert';

// This file now correctly defines two classes: BusRoute and Stop.

class BusRoute {
    // It's better practice to use final for properties that don't change
    // after the object is created.
    final int routeNumber;
    final String origin;
    final String destination;
    // final int distance; // Uncomment if your JSON actually has a 'distance' field
    final List<Stop> stops;

    BusRoute({
        required this.routeNumber,
        required this.origin,
        required this.destination,
        // required this.distance, // Uncomment if you have this field
        required this.stops,
    });

    // The fromJson factory constructor now correctly parses the JSON for a single route.
    factory BusRoute.fromJson(Map<String, dynamic> json) => BusRoute(
        routeNumber: json["routeNumber"],
        origin: json["origin"],
        destination: json["destination"],
        // distance: json["distance"], // Uncomment if you have this field
        stops: List<Stop>.from(json["stops"].map((x) => Stop.fromJson(x))),
    );

    // The toJson method is useful if you ever need to send data back to a server.
    Map<String, dynamic> toJson() => {
        "routeNumber": routeNumber,
        "origin": origin,
        "destination": destination,
        // "distance": distance, // Uncomment if you have this field
        "stops": List<dynamic>.from(stops.map((x) => x.toJson())),
    };
}

class Stop {
    final int stopNumber;
    final String stopName;

    Stop({
        required this.stopNumber,
        required this.stopName,
    });

    // Note how this matches the keys in your JSON: "stop_number" and "stop_name"
    factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        stopNumber: json["stop_number"],
        stopName: json["stop_name"],
    );

    Map<String, dynamic> toJson() => {
        "stop_number": stopNumber,
        "stop_name": stopName,
    };
}