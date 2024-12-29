import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/services/history_service.dart';
import 'package:remind/models/category_model.dart';
import 'package:remind/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

final historyProvider = FutureProvider.family<List<TaskHistory>, DateTimeRange>((ref, dateRange) async {
  final historyService = HistoryService();
  return historyService.getHistory(
    startDate: dateRange.start,
    endDate: dateRange.end,
  );
});

final pointsByCategoryProvider = FutureProvider.family<Map<String, int>, DateTimeRange>((ref, dateRange) async {
  final historyService = HistoryService();
  return historyService.getPointsByCategory(
    startDate: dateRange.start,
    endDate: dateRange.end,
  );
});

final dailyPointsProvider = FutureProvider.family<List<MapEntry<DateTime, int>>, DateTimeRange>((ref, dateRange) async {
  final historyService = HistoryService();
  return historyService.getDailyPoints(
    startDate: dateRange.start,
    endDate: dateRange.end,
  );
});

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(historyProvider(_dateRange));
    final pointsByCategory = ref.watch(pointsByCategoryProvider(_dateRange));
    final dailyPoints = ref.watch(dailyPointsProvider(_dateRange));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () async {
              final newRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _dateRange,
              );
              if (newRange != null) {
                setState(() => _dateRange = newRange);
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        children: [
          _buildDateRangeHeader(),
          const SizedBox(height: 24),
          _buildPointsChart(dailyPoints),
          const SizedBox(height: 24),
          _buildCategoryDistribution(pointsByCategory),
          const SizedBox(height: 24),
          _buildHistoryList(history),
        ],
      ),
    );
  }

  Widget _buildDateRangeHeader() {
    return Text(
      '${DateFormat.yMMMd().format(_dateRange.start)} - '
      '${DateFormat.yMMMd().format(_dateRange.end)}',
      style: AppConstants.headerStyle,
      textAlign: TextAlign.center,
    );
  }

  Widget _buildPointsChart(AsyncValue<List<MapEntry<DateTime, int>>> dailyPoints) {
    return SizedBox(
      height: 200,
      child: dailyPoints.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          return LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() >= 0 && value.toInt() < data.length) {
                        return Text(
                          DateFormat.Md().format(data[value.toInt()].key),
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: data.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(), entry.value.value.toDouble());
                  }).toList(),
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildCategoryDistribution(AsyncValue<Map<String, int>> pointsByCategory) {
    return pointsByCategory.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No data available'));
        }

        final total = data.values.reduce((a, b) => a + b);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category Distribution', style: AppConstants.headerStyle),
            const SizedBox(height: 16),
            ...data.entries.map((entry) {
              final category = TaskCategory.defaultCategories
                  .firstWhere((c) => c.id == entry.key);
              final percentage = (entry.value / total * 100).toStringAsFixed(1);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(category.icon, color: category.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category.name),
                          LinearProgressIndicator(
                            value: entry.value / total,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(category.color),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('$percentage%'),
                  ],
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildHistoryList(AsyncValue<List<TaskHistory>> history) {
    return history.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(child: Text('No completed tasks in this period'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Completed Tasks', style: AppConstants.headerStyle),
            const SizedBox(height: 16),
            ...data.map((item) {
              final category = TaskCategory.defaultCategories
                  .firstWhere((c) => c.id == item.categoryId);
              
              return Card(
                child: ListTile(
                  leading: Icon(category.icon, color: category.color),
                  title: Text(item.title),
                  subtitle: Text(DateFormat.yMMMd().add_Hm()
                      .format(item.completedAt)),
                  trailing: Text(
                    '+${item.points}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
} 