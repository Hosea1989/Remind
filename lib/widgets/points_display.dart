import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/providers/points_provider.dart';
import 'package:remind/utils/constants.dart';

class PointsDisplay extends ConsumerWidget {
  const PointsDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(pointsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Available Points',
              style: AppConstants.subheaderStyle,
            ),
            const SizedBox(height: 8),
            Text(
              points.availablePoints.toString(),
              style: AppConstants.headerStyle.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Divider(),
            Text(
              'Total Points Earned',
              style: AppConstants.subheaderStyle,
            ),
            const SizedBox(height: 8),
            Text(
              points.totalPoints.toString(),
              style: AppConstants.headerStyle,
            ),
          ],
        ),
      ),
    );
  }
} 