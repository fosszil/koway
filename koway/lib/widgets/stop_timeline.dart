import 'package:flutter/material.dart';
import '../models/bus_routes.dart';

class StopTimeline extends StatelessWidget {
  final List<Stop> stops;
  final Color color;

  const StopTimeline({super.key, required this.stops, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      itemCount: stops.length,
      itemBuilder: (context, index) {
        final isFirst = index == 0;
        final isLast = index == stops.length - 1;

        return SizedBox(
          height: 64,
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: isFirst ? 32 : 0,
                      bottom: isLast ? 32 : 0,
                      child: Container(width: 4, color: color),
                    ),
                    Container(
                      width: isFirst || isLast ? 18 : 14,
                      height: isFirst || isLast ? 18 : 14,
                      decoration: BoxDecoration(
                        color: isFirst || isLast ? color : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: color, width: 4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  stops[index].stopName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                '${index + 1}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
