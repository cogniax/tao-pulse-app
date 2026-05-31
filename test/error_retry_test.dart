import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:taopulse/shared/widgets/error_retry_view.dart';

void main() {
  testWidgets('ErrorRetryView shows the message and fires onRetry on tap', (
    tester,
  ) async {
    var retries = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorRetryView(
            message: 'Network unavailable.',
            onRetry: () => retries++,
          ),
        ),
      ),
    );

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Network unavailable.'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    expect(retries, 1);
  });

  testWidgets('ErrorRetryView accepts a custom title', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorRetryView(
            title: 'Offline',
            message: 'No connection.',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('Offline'), findsOneWidget);
  });
}
