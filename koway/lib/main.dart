import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // Import the new screen
import 'services/route_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await RouteService.instance.fetchAllRoutes();
  await RouteService.instance.loadSearchIndex();

  runApp(const KowayTravel());
}

class KowayTravel extends StatelessWidget {
  const KowayTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Koway",
      theme: ThemeData(
        useMaterial3: true, 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal, 
          brightness: Brightness.light,
        ),
      ),
      home: const MainScreen(),
    );
  }
}