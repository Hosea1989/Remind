import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/utils/constants.dart';
import 'package:remind/providers/points_provider.dart';
import 'package:remind/services/database_service.dart';
import 'package:intl/intl.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  final _db = DatabaseService();
  Map<String, int> _weeklyStats = {};
  Map<String, int> _monthlyStats = {};

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthAgo = now.subtract(const Duration(days: 30));

    final weeklyStats = await _db.getStatisticsForRange(weekAgo, now);
    final monthlyStats = await _db.getStatisticsForRange(monthAgo, now);

    setState(() {
      _weeklyStats = weeklyStats;
      _monthlyStats = monthlyStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final points = ref.watch(pointsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadStatistics,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          children: [
            _buildStatCard(
              'Current Points',
              points.availablePoints.toString(),
              Icons.stars,
            ),
            const SizedBox(height: 16),
            _buildPeriodStats('This Week', _weeklyStats),
            const SizedBox(height: 16),
            _buildPeriodStats('This Month', _monthlyStats),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8),
            Text(title, style: AppConstants.subheaderStyle),
            Text(value, style: AppConstants.headerStyle),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodStats(String period, Map<String, int> stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(period, style: AppConstants.headerStyle),
            const SizedBox(height: 16),
            _buildStatRow('Tasks Completed', stats['tasksCompleted'] ?? 0),
            _buildStatRow('Points Earned', stats['pointsEarned'] ?? 0),
            _buildStatRow('Rewards Redeemed', stats['rewardsRedeemed'] ?? 0),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppConstants.subheaderStyle),
          Text(value.toString(), style: AppConstants.subheaderStyle),
        ],
      ),
    );
  }
} 