import 'package:flutter/material.dart';
import 'package:remind/models/reward_model.dart';

class RewardCard extends StatelessWidget {
  final Reward? reward;

  const RewardCard({super.key, this.reward});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard, size: 48),
            const SizedBox(height: 8),
            Text(
              reward?.title ?? 'Loading...',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('${reward?.points ?? 0} points'),
          ],
        ),
      ),
    );
  }
} 