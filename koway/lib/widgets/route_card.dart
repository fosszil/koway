import 'package:flutter/material.dart';

import '../models/bus_routes.dart';
import '../theme/app_theme.dart';

const _routeColors = [
  AppColors.lime,
  AppColors.mint,
  AppColors.blue,
  AppColors.orange,
];

Color routeColor(String routeNumber) {
  final value = routeNumber.codeUnits.fold(0, (sum, unit) => sum + unit);
  return _routeColors[value % _routeColors.length];
}

Color routeTextColor(String routeNumber) {
  final color = routeColor(routeNumber);
  return color.computeLuminance() > 0.45 ? AppColors.ink : AppColors.surface;
}

class RouteCard extends StatelessWidget {
  final BusRoute route;
  final VoidCallback onTap;
  final bool compact;

  const RouteCard({
    super.key,
    required this.route,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final accentColor = routeColor(route.routeNumber);
    final accentTextColor = routeTextColor(route.routeNumber);
    final badgeSize = compact ? 48.0 : 64.0;
    final cardPadding = compact ? AppSpacing.md : AppSpacing.lg;

    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: AppSpacing.xs, color: accentColor),
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Row(
                children: [
                  Container(
                    width: badgeSize,
                    height: badgeSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(AppRadius.control),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Text(
                          route.routeNumber,
                          style: TextStyle(
                            color: accentTextColor,
                            fontSize: compact ? 18 : 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${route.origin} → ${route.destination}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.ink,
                            fontSize: compact ? 13 : 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${route.stops.length} stops · View route',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.muted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
