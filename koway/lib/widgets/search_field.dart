import 'package:flutter/material.dart'; 
import '../services/route_service.dart';

class SearchField extends StatelessWidget {
  final String label;

  const SearchField({super.key,required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText:label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
        )
      ),
    )
}