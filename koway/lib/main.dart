import 'package:flutter/material.dart';
import 'screens/main_screen.dart'; // Import the new screen
import 'services/route_service.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.light,
      home: const MainScreen(),
    );
  }
}
