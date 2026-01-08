import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String label;

  const SearchField({super.key,required this.label});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState(){
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        suffixIcon: IconButton(onPressed: _controller.clear, icon: Icon(Icons.clear))
      ),  
    );
  }
}
