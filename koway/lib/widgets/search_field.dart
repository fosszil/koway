import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;  
  

  const SearchField({
    super.key,
    required this.label,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onClear,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: (_)=> widget.onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: (){
            widget.controller.clear();
            if (widget.onChanged != null) widget.onChanged!("");
            if (widget.onClear != null) widget.onClear!();
            setState(() {});
          },
        )
      ),  
    );
  }
}
