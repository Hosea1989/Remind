import 'package:flutter/material.dart';
import 'package:remind/utils/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remind'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Progress Overview
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Tasks\nCompleted', '12'),
                    _buildStatCard('Points\nEarned', '240'),
                    _buildStatCard('Rewards\nRedeemed', '3'),
                  ],
                ),
              ),
            ),
          ),
          // Quick Actions
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              children: [
                _buildQuickActionCard(
                  context,
                  'Tasks',
                  Icons.task_alt,
                  AppRoutes.tasks,
                ),
                _buildQuickActionCard(
                  context,
                  'Rewards',
                  Icons.card_giftcard,
                  AppRoutes.rewards,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add new task
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
} 