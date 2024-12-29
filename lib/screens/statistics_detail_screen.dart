import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/providers/statistics_provider.dart';
import 'package:remind/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsDetailScreen extends ConsumerWidget {
  const StatisticsDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Statistics'),
                  content: const Text(
                    'Are you sure you want to reset all statistics? This cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(statisticsProvider.notifier).resetStatistics();
                        Navigator.pop(context);
                      },
                      child: const Text('Reset'),
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                  ],
                ),
              );
            },
            tooltip: 'Reset Statistics',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildStatCard(
            context,
            'Tasks Completed',
            stats.completedTasks.toString(),
            Icons.task_alt,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            context,
            'Total Points',
            stats.totalPoints.toString(),
            Icons.stars,
          ),
          const SizedBox(height: 16),
          _buildStatCard(
            context,
            'Current Streak',
            '${stats.currentStreak} days',
            Icons.local_fire_department,
          ),
          const SizedBox(height: 32),
          const Text(
            'Weekly Progress',
            style: AppConstants.headerStyle,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                // TODO: Implement chart data
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      const FlSpot(0, 3),
                      const FlSpot(1, 1),
                      const FlSpot(2, 4),
                      const FlSpot(3, 2),
                      const FlSpot(4, 5),
                      const FlSpot(5, 3),
                      const FlSpot(6, 4),
                    ],
                    isCurved: true,
                    color: Theme.of(context).primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppConstants.subheaderStyle),
                Text(
                  value,
                  style: AppConstants.headerStyle.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 