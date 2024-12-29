import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remind/main.dart';
import 'package:remind/widgets/task_card.dart';
import 'package:remind/widgets/reward_card.dart';
import 'package:remind/widgets/points_display.dart';
import 'package:remind/models/task_model.dart';
import 'package:remind/models/reward_model.dart';

void main() {
  testWidgets('RemindApp should build without errors', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: RemindApp(),
      ),
    );

    expect(find.text('Remind'), findsOneWidget);
  });

  testWidgets('TaskCard displays task information correctly', (WidgetTester tester) async {
    final task = Task(
      id: '1',
      title: 'Test Task',
      description: 'Test Description',
      dueDate: DateTime.now(),
      points: 100,
      categoryId: '1',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(task: task),
        ),
      ),
    );

    expect(find.text('Test Task'), findsOneWidget);
    expect(find.text('Test Description'), findsOneWidget);
    expect(find.text('100 pts'), findsOneWidget);
  });

  testWidgets('RewardCard displays reward information correctly', (WidgetTester tester) async {
    final reward = Reward(
      id: '1',
      title: 'Test Reward',
      description: 'Test Description',
      points: 200,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RewardCard(reward: reward),
        ),
      ),
    );

    expect(find.text('Test Reward'), findsOneWidget);
    expect(find.text('200 points'), findsOneWidget);
  });

  testWidgets('PointsDisplay shows points correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: PointsDisplay(),
          ),
        ),
      ),
    );

    expect(find.text('Available Points'), findsOneWidget);
    expect(find.text('Total Points Earned'), findsOneWidget);
  });
} 