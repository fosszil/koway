import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
    this.suggestions = const [],
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  InputDecoration _buildDecoration(TextEditingController localController) {
    return InputDecoration(
      hintText: widget.label,
      hintStyle: const TextStyle(
        color: AppColors.muted,
        fontWeight: FontWeight.w600,
      ),
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      prefixIcon: const Icon(Icons.search, color: AppColors.forest),
      suffixIcon: localController.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              color: AppColors.forest,
              tooltip: 'Clear search',
              onPressed: () {
                localController.clear();

                if (localController != widget.controller) {
                  widget.controller.clear();
                }
                widget.onChanged?.call('');
                widget.onClear?.call();
                setState(() {});
              },
            )
          : null,
      border: _border(AppColors.surface),
      enabledBorder: _border(AppColors.surface),
      focusedBorder: _border(AppColors.lime),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.card),
      borderSide: BorderSide(color: color, width: 1.5),
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
          setState(() {});
          widget.onChanged?.call(value);
        },
        decoration: _buildDecoration(widget.controller),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Autocomplete<String>(
          optionsBuilder: (value) {
            if (value.text.isEmpty) return const Iterable<String>.empty();

            return widget.suggestions.where(
              (option) =>
                  option.toLowerCase().contains(value.text.toLowerCase()),
            );
          },
          onSelected: (selection) {
            widget.controller.text = selection;
            setState(() {});
            widget.onChanged?.call(selection);
          },
          fieldViewBuilder:
              (context, fieldController, focusNode, onFieldSubmitted) {
                if (widget.controller.text != fieldController.text) {
                  fieldController.text = widget.controller.text;
                  fieldController.selection = TextSelection.fromPosition(
                    TextPosition(offset: fieldController.text.length),
                  );
                }

                return TextField(
                  controller: fieldController,
                  focusNode: focusNode,
                  onSubmitted: (_) => widget.onSubmitted?.call(),
                  textInputAction: TextInputAction.search,
                  onChanged: (value) {
                    widget.controller.text = value;
                    setState(() {});
                    widget.onChanged?.call(value);
                  },
                  decoration: _buildDecoration(fieldController),
                );
              },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 0,
                borderRadius: BorderRadius.circular(AppRadius.control),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth,
                    maxHeight: 200,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppRadius.control),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.xs,
                    ),
                    shrinkWrap: true,
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 1,
                      color: AppColors.divider,
                      indent: AppSpacing.lg,
                      endIndent: AppSpacing.lg,
                    ),
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);

                      return ListTile(
                        leading: const Icon(
                          Icons.search,
                          size: 18,
                          color: AppColors.muted,
                        ),
                        title: Text(option),
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
