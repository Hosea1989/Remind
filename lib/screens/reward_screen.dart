import 'package:flutter/material.dart';
import 'package:remind/models/reward_model.dart';

class RewardScreen extends StatelessWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 0, // TODO: Replace with actual rewards length
        itemBuilder: (context, index) {
          return const RewardCard(); // TODO: Pass actual reward data
        },
      ),
    );
  }
} 