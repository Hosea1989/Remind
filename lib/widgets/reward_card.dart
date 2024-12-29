import 'package:flutter/material.dart';
import 'package:remind/models/reward_model.dart';

class RewardCard extends StatelessWidget {
  final Reward? reward;

  const RewardCard({super.key, this.reward});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          // TODO: Implement reward redemption
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.card_giftcard,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              reward?.title ?? 'Sample Reward',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '${reward?.points ?? 100} points',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
} 