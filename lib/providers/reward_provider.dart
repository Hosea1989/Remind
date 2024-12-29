import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/models/reward_model.dart';

final rewardListProvider = StateNotifierProvider<RewardNotifier, List<Reward>>((ref) {
  return RewardNotifier();
});

class RewardNotifier extends StateNotifier<List<Reward>> {
  RewardNotifier() : super([]);

  void addReward(Reward reward) {
    state = [...state, reward];
  }

  void redeemReward(String rewardId) {
    state = [
      for (final reward in state)
        if (reward.id == rewardId)
          reward.copyWith(isAvailable: false)
        else
          reward,
    ];
  }
} 