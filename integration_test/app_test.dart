import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:remind/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-end test', () {
    testWidgets('Create and complete a task flow', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: RemindApp(),
        ),
      );

      // Navigate to tasks screen
      await tester.tap(find.text('Tasks'));
      await tester.pumpAndSettle();

      // Open create task dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill in task details
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter task title'),
        'Integration Test Task',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter task description'),
        'Testing task creation',
      );

      // Create task
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      // Verify task was created
      expect(find.text('Integration Test Task'), findsOneWidget);
      expect(find.text('Testing task creation'), findsOneWidget);
    });

    testWidgets('Settings interaction flow', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: RemindApp(),
        ),
      );

      // Navigate to settings
      await tester.tap(find.byIcon(Icons.settings));
      await tester.pumpAndSettle();

      // Toggle dark mode
      await tester.tap(find.widgetWithText(Switch, 'Dark Mode'));
      await tester.pumpAndSettle();

      // Toggle notifications
      await tester.tap(find.widgetWithText(Switch, 'Notifications'));
      await tester.pumpAndSettle();
    });
  });
} 