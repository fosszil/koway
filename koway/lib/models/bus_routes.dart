class BusRoute {
  final int routeNumber;
  final String origin;
  final String destination;
  final List<Stop> stops;

  BusRoute({
    required this.routeNumber,
    required this.origin,
    required this.destination,
    required this.stops,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      // Use safe defaults in case fields are missing or null
      routeNumber: json["routeNumber"] is int
          ? json["routeNumber"]
          : int.tryParse(json["routeNumber"]?.toString() ?? "0") ?? 0,
      origin: json["origin"] ?? "Unknown",
      destination: json["destination"] ?? "Unknown",
      stops: (json["stops"] as List<dynamic>? ?? [])
          .map((x) => Stop.fromJson(Map<String, dynamic>.from(x)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "routeNumber": routeNumber,
        "origin": origin,
        "destination": destination,
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

  factory Stop.fromJson(Map<String, dynamic> json) {
    return Stop(
      stopNumber: json["stop_number"] is int
          ? json["stop_number"]
          : int.tryParse(json["stop_number"]?.toString() ?? "0") ?? 0,
      stopName: json["stop_name"] ?? "Unnamed Stop",
    );
  }

  Map<String, dynamic> toJson() => {
        "stop_number": stopNumber,
        "stop_name": stopName,
      };
}
