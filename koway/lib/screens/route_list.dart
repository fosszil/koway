import 'package:flutter/material.dart';
import '../models/bus_routes.dart';
import '../services/route_service.dart';

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  late Future<List<BusRoute>> futureRoutes;

  @override
  void initState() {
    super.initState();
    futureRoutes = fetchRoutes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coimbatore Bus Routes"),
      ),
      body: FutureBuilder<List<BusRoute>>(
        future: futureRoutes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No routes available"));
          } else {
            final routes = snapshot.data!;
            return ListView.builder(
              itemCount: routes.length,
              itemBuilder: (context, index) {
                final route = routes[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: ListTile(
                    title: Text("🚌 Route ${route.routeNumber}"),
                    subtitle: Text("${route.origin} → ${route.destination}"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RouteDetailScreen(route: route),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class RouteDetailScreen extends StatelessWidget {
  final BusRoute route;
  const RouteDetailScreen({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Route ${route.routeNumber}")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${route.origin} → ${route.destination}",
                style: Theme.of(context).textTheme.titleLarge),
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
        ),
      ),
    );
  }
}
