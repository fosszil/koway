import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'route_card.dart';

class IndirectRouteCard extends StatelessWidget {
  final String origin;
  final String destination;
  final String transferStop;
  final List<String> firstLegRoutes;
  final List<String> secondLegRoutes;

  const IndirectRouteCard({
    super.key,
    required this.origin,
    required this.destination,
    required this.transferStop,
    required this.firstLegRoutes,
    required this.secondLegRoutes,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.card),
        side: const BorderSide(color: AppColors.divider),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Stack(
          children: [
            Positioned(
              left: 16,
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Container(width: 2, color: AppColors.divider),
            ),
            Column(
              children: [
                _LegSection(
                  label: 'From $origin',
                  title: 'Buses to $transferStop',
                  routeNumbers: firstLegRoutes,
                  marker: const _TimelineMarker.circle(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: _TransferSection(transferStop: transferStop),
                ),
                _LegSection(
                  label: 'From $transferStop',
                  title: 'Buses to $destination',
                  routeNumbers: secondLegRoutes,
                  marker: const _TimelineMarker.square(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LegSection extends StatelessWidget {
  final String label;
  final String title;
  final List<String> routeNumbers;
  final Widget marker;

  const _LegSection({
    required this.label,
    required this.title,
    required this.routeNumbers,
    required this.marker,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 36, child: Center(child: marker)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final routeNumber in routeNumbers)
                    _RouteNumberBadge(routeNumber: routeNumber),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransferSection extends StatelessWidget {
  final String transferStop;

  const _TransferSection({required this.transferStop});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 36,
          child: Center(
            child: Container(
              width: 30,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.forest,
                borderRadius: BorderRadius.circular(AppRadius.control),
              ),
              child: const Icon(
                Icons.swap_vert,
                color: AppColors.lime,
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lime.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(AppRadius.control),
              border: Border.all(color: AppColors.lime.withValues(alpha: 0.75)),
            ),
            child: Text(
              'Change at $transferStop\nThen choose a bus below',
              style: const TextStyle(
                color: AppColors.forest,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteNumberBadge extends StatelessWidget {
  final String routeNumber;

  const _RouteNumberBadge({required this.routeNumber});

  @override
  Widget build(BuildContext context) {
    final color = routeColor(routeNumber);

    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          routeNumber,
          style: TextStyle(
            color: routeTextColor(routeNumber),
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _TimelineMarker extends StatelessWidget {
  final BoxShape shape;
  final Color color;

  const _TimelineMarker.circle()
    : shape = BoxShape.circle,
      color = AppColors.forest;

  const _TimelineMarker.square()
    : shape = BoxShape.rectangle,
      color = AppColors.pink;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(color: color, shape: shape),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: shape,
          borderRadius: shape == BoxShape.rectangle
              ? BorderRadius.circular(3)
              : null,
        ),
      ),
    );
  }
}
