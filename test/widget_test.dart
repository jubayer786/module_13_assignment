import 'package:flutter_test/flutter_test.dart';
import 'package:module_13_assignment/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskManagerApp());
    expect(find.byType(TaskManagerApp), findsOneWidget);

    // Fast-forward past the splash screen timer
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
