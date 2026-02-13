import 'package:flutter/material.dart';

class DoubleInputCard extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destController;
  final List<String> suggestions;
  final VoidCallback onSearch;

  const DoubleInputCard({
    super.key,
    required this.originController,
    required this.destController,
    required this.suggestions,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left: Visual Connector
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green.shade500,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 1.5,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      color: Colors.grey.shade200,
                    ),
                  ),
                  Icon(
                    Icons.location_on,
                    color: Colors.red.shade400,
                    size: 16,
                  ),
                ],
              ),
            ),

            // Right: Inputs
            Expanded(
              child: Column(
                children: [
                  _buildInput("Starting point", originController),
                  Divider(height: 1, thickness: 1, color: Colors.grey.shade100),
                  _buildInput("Destination", destController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String hint, TextEditingController controller) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue val) {
        if (val.text.isEmpty) return const Iterable<String>.empty();
        return suggestions.where(
          (option) => option.toLowerCase().contains(val.text.toLowerCase()),
        );
      },
      onSelected: (String selection) {
        controller.text = selection;
        onSearch();
      },
      fieldViewBuilder: (context, fieldController, focusNode, onFieldSubmitted) {
        if (controller.text != fieldController.text) {
          fieldController.text = controller.text;
          fieldController.selection = TextSelection.fromPosition(
            TextPosition(offset: fieldController.text.length),
          );
        }

        return TextField(
          controller: fieldController,
          focusNode: focusNode,
          onSubmitted: (_) => onSearch(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w400,
              fontSize: 15,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 16,
            ),
            isDense: true,
          ),
          onChanged: (val) => controller.text = val,
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.grey.shade100,
                  indent: 16,
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  final String option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
