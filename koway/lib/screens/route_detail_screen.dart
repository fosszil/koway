import 'package:flutter/material.dart';
import '../models/bus_routes.dart';

class RouteDetailScreen extends StatelessWidget{
  final BusRoute route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route: ${route.routeNumber}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${route.origin} → ${route.destination}",
              style: Theme.of(context).textTheme.titleLarge,),
            const Divider(height: 24),
            Text("Stops:", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: route.stops.length,
                itemBuilder: (context, index) {
                  final stop = route.stops[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text("${stop.stopNumber}")),
                    title: Text(stop.stopName),
                  );
                },
              ),
            )
          ],
        ),)
    );
  }
}