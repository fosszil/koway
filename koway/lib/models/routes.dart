class BusRoute {
  final int routeNumber;
  final String origin;
  final String destination;
  final int distance;
  final List<BusStop> stops;

  BusRoute({
    required this.routeNumber,
    required this.origin,
    required this.destination,
    required this.distance,
    required this.stops,
  });

  factory BusRoute.fromJson(Map<String, dynamic> json) {
    return BusRoute(
      routeNumber: json['routeNumber'],
      origin: json['origin'],
      destination: json['destination'],
      distance: json['distance'],
      stops: (json['stops'] as List)
          .map((stop) => BusStop.fromJson(stop))
          .toList(),
    );
  }
}

class BusStop {
  final int stopNumber;
  final String stopName;

  BusStop({required this.stopNumber, required this.stopName});

  factory BusStop.fromJson(Map<String, dynamic> json) {
    return BusStop(
      stopNumber: json['stop_number'],
      stopName: json['stop_name'],
    );
  }
}
