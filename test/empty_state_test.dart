import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taopulse/shared/widgets/empty_state_view.dart';

void main() {
  testWidgets('EmptyStateView renders the title and message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: EmptyStateView(
            title: 'No alerts yet',
            message: "You're all caught up.",
          ),
        ),
      ),
    );

    expect(find.text('No alerts yet'), findsOneWidget);
    expect(find.text("You're all caught up."), findsOneWidget);
  });

  testWidgets('RefreshableEmpty keeps its child scrollable for refresh', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RefreshableEmpty(
            child: EmptyStateView(title: 'Empty', message: 'Nothing here.'),
          ),
        ),
      ),
    );

    expect(find.text('Empty'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
