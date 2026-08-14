import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'koway_app_header.dart';

class DoubleInputCard extends StatelessWidget {
  final TextEditingController originController;
  final TextEditingController destController;
  final List<String> suggestions;
  final VoidCallback onSwap;
  final VoidCallback onSearch;

  const DoubleInputCard({
    super.key,
    required this.originController,
    required this.destController,
    required this.suggestions,
    required this.onSwap,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return KowayAppHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  AppSpacing.xs,
                  52,
                  AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  children: [
                    _InputRow(
                      hint: 'Starting stop',
                      controller: originController,
                      suggestions: suggestions,
                      marker: const _StopMarker(shape: BoxShape.circle),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _InputRow(
                      hint: 'Destination stop',
                      controller: destController,
                      suggestions: suggestions,
                      marker: const _StopMarker(shape: BoxShape.rectangle),
                    ),
                  ],
                ),
              ),
              _SwapButton(onPressed: onSwap),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onSearch,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                backgroundColor: AppColors.lime,
                foregroundColor: AppColors.forest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.control),
                ),
              ),
              child: const Text(
                'Find direct buses',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final List<String> suggestions;
  final Widget marker;

  const _InputRow({
    required this.hint,
    required this.controller,
    required this.suggestions,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 32, child: marker),
        Expanded(
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue val) {
              if (val.text.isEmpty) return const Iterable<String>.empty();
              return suggestions.where(
                (option) =>
                    option.toLowerCase().contains(val.text.toLowerCase()),
              );
            },
            onSelected: (String selection) {
              controller.text = selection;
            },
            fieldViewBuilder:
                (context, fieldController, focusNode, onFieldSubmitted) {
                  if (controller.text != fieldController.text) {
                    fieldController.text = controller.text;
                    fieldController.selection = TextSelection.fromPosition(
                      TextPosition(offset: fieldController.text.length),
                    );
                  }

                  return ValueListenableBuilder(
                    valueListenable: fieldController,
                    builder: (context, value, child) {
                      return TextField(
                        controller: fieldController,
                        focusNode: focusNode,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.ink,
                        ),
                        decoration: InputDecoration(
                          hintText: hint,
                          hintStyle: const TextStyle(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                          isDense: true,

                          suffixIcon: value.text.isEmpty
                              ? null
                              : IconButton(
                                  onPressed: fieldController.clear,
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 18,
                                    color: AppColors.muted,
                                  ),
                                  tooltip: "Clear $hint",
                                ),
                        ),
                        onChanged: (value) => controller.text = value,
                      );
                    },
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(AppRadius.control),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 200),
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
                        final String option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.lg,
                              vertical: AppSpacing.md,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.muted,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.ink,
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
          ),
        ),
      ],
    );
  }
}

class _StopMarker extends StatelessWidget {
  final BoxShape shape;

  const _StopMarker({required this.shape});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightForest, width: 3),
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(3)
              : null,
          shape: shape,
        ),
      ),
    );
  }
}

class _SwapButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SwapButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: IconButton.filled(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFEDF1ED),
          foregroundColor: AppColors.forest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11),
          ),
        ),
        icon: const Icon(Icons.swap_vert),
        tooltip: 'Swap stops',
      ),
    );
  }
}
