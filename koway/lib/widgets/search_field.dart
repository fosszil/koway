import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;  

  final List<String> suggestions; 

  const SearchField({
    super.key,
    required this.label,
    required this.controller,
    this.onSubmitted,
    this.onChanged,
    this.onClear,
    this.suggestions = const[];
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onSubmitted: (_) {
        if (widget.onSubmitted != null) {
          widget.onSubmitted!();
        }
      },
      textInputAction: TextInputAction.search,
      
      onChanged: (value) {
        setState(() {});
        if (widget.onChanged != null){
          widget.onChanged!(value);
        }
      },
      decoration: InputDecoration(
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Theme.of(context).scaffoldBackgroundColor,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.controller.text.isNotEmpty ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: (){
            widget.controller.clear();
            if (widget.onChanged != null) widget.onChanged!("");
            setState(() {});
          },
        )
        : null,
      ),  
    );
  }
}
