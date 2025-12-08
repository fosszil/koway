import 'package:flutter/material.dart';
import 'screens/route_list.dart';
import 'services/route_service.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final routes = await fetchRoutes();
  for (var r in routes) {
    print("${r.routeNumber}: ${r.origin} → ${r.destination} (${r.stops.length} stops)");
  }
  runApp(const KowayTravel());
}


class KowayTravel extends StatelessWidget{
  const KowayTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Koway",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const RoutesListScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Koway")),
      body: const Center(
        child: Text(
          "Find your way around Kovai 👋",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
