import 'package:flutter/material.dart';

void main(){
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
      home: const HomeScreen(),
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