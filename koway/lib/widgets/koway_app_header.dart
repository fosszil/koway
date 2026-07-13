import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class KowayAppHeader extends StatelessWidget {
  final Widget child;

  const KowayAppHeader({super.key, required this.child});

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
      decoration: const BoxDecoration(
        color: AppColors.forest,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(AppRadius.header),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _KowayBrand(),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _KowayBrand extends StatelessWidget {
  const _KowayBrand();

  @override
  Widget build(BuildContext context) {
    return const Row(
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
        Spacer(),
        Flexible(
          child: Text(
            'Find Buses in Coimbatore',
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Color(0xB3FFFFFF),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
