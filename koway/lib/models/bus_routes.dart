class BusRoute {
  final String routeNumber;
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
    var rawStops = json["stops"] as List<dynamic>? ?? [];
    
    List<Stop> parsedStops = rawStops.asMap().entries.map((entry) {
      int index = entry.key;
      Map<String, dynamic> value = Map<String, dynamic>.from(entry.value);
      
      // Pass the index + 1 so stops are numbered 1, 2, 3...
      return Stop.fromJson(value, fallbackNumber: index + 1);
    }).toList();

    return BusRoute(
      routeNumber: json["routeNumber"].toString(),
      origin: json["origin"] ?? "Unknown",
      destination: json["destination"] ?? "Unknown",
      stops: parsedStops,
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

  factory Stop.fromJson(Map<String, dynamic> json, {int fallbackNumber = 0}) {
    return Stop(
      stopNumber: json["stop_number"] != null 
          ? int.tryParse(json["stop_number"].toString()) ?? fallbackNumber 
          : fallbackNumber,
      stopName: json["stop_name"] ?? "Unnamed Stop",
    );
  }

  Map<String, dynamic> toJson() => {
        "stop_number": stopNumber,
        "stop_name": stopName,
      };
}