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
    return Row(
      children: [
        Image.asset('assets/images/koway_logo.png', width: 36, height: 36),
        SizedBox(width: AppSpacing.xs),
        Text(
          'Koway',
          style: TextStyle(
            color: AppColors.surface,
            fontSize: 20,
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
