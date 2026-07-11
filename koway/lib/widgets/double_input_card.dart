import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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
    final topPadding = MediaQuery.paddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        topPadding + AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.forest,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.header),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _HeaderTitle(),
          const SizedBox(height: AppSpacing.md),
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
                      onSearch: onSearch,
                      marker: const _StopMarker(shape: BoxShape.circle),
                    ),
                    const Divider(height: 1, color: AppColors.divider),
                    _InputRow(
                      hint: 'Destination stop',
                      controller: destController,
                      suggestions: suggestions,
                      onSearch: onSearch,
                      marker: const _StopMarker(shape: BoxShape.rectangle),
                    ),
                  ],
                ),
              ),
              _SwapButton(
                onPressed: () {
                  final origin = originController.text;
                  originController.text = destController.text;
                  destController.text = origin;
                },
              ),
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

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.directions_bus, color: AppColors.lime, size: 22),
            SizedBox(width: AppSpacing.sm),
            Text(
              'Koway',
              style: TextStyle(
                color: AppColors.surface,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Text(
          'Coimbatore',
          style: TextStyle(
            color: Color(0xB3FFFFFF),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _InputRow extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final List<String> suggestions;
  final VoidCallback onSearch;
  final Widget marker;

  const _InputRow({
    required this.hint,
    required this.controller,
    required this.suggestions,
    required this.onSearch,
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
              onSearch();
            },
            fieldViewBuilder:
                (context, fieldController, focusNode, onFieldSubmitted) {
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
                      contentPadding: const EdgeInsets.symmetric(vertical: 13),
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
