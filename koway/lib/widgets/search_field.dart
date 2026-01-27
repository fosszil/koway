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
    this.suggestions = const[]
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  InputDecoration _buildDecoration(BuildContext context, TextEditingController localController){
    return InputDecoration(
      labelText: widget.label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      prefixIcon: const Icon(Icons.search),
      suffixIcon: localController.text.isNotEmpty ? IconButton(
          icon: const Icon(Icons.clear),
          onPressed: (){
            localController.clear();

            if(localController != widget.controller){
              widget.controller.clear();
            }
            if(widget.onChanged!=null) widget.onChanged!("");
            if(widget.onClear!=null) widget.onClear!();
            setState(() {});
          },
      )
      : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.suggestions.isEmpty) {
      return TextField(
        controller: widget.controller,
        onSubmitted: (_) => widget.onSubmitted?.call(),
        textInputAction: TextInputAction.search,
        onChanged: (value) {
          setState(() {}); // specific to update clear icon
          widget.onChanged?.call(value);
        },
        decoration: _buildDecoration(context, widget.controller),
      );
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return widget.suggestions.where((String option) {
            return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (String selection) {
          widget.controller.text = selection;
          setState(() {});
          widget.onChanged?.call(selection);
        },
        fieldViewBuilder: (context, fieldTextController, focusNode, onFieldSubmitted) {
          if (widget.controller.text != fieldTextController.text) {
             fieldTextController.text = widget.controller.text;
             fieldTextController.selection = TextSelection.fromPosition(
                TextPosition(offset: fieldTextController.text.length));
          }

          return TextField(
            controller: fieldTextController,
            focusNode: focusNode,
            onSubmitted: (_) => widget.onSubmitted?.call(),
            textInputAction: TextInputAction.search,
            onChanged: (value) {
              widget.controller.text = value;
              setState(() {});
              widget.onChanged?.call(value);
            },
            decoration: _buildDecoration(context, fieldTextController),
          );
        },
        optionsViewBuilder: (context, onSelected, options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4.0,
              child: SizedBox(
                width: constraints.maxWidth,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String option = options.elementAt(index);
                    return ListTile(
                      title: Text(option),
                      onTap: () {
                        onSelected(option);
                      },
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    });
  }
}