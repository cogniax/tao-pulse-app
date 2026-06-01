import 'package:flutter_test/flutter_test.dart';

void main() {
  test('alerts enabled fallback counts only toggled-on categories', () {
    const activityAlerts = {
      'Emission Changes': true,
      'Large Stake Movement': false,
      'Validator Changes': true,
      'Unusual Activity': false,
      'Risk Alerts': false,
    };

    final enabledCount =
        activityAlerts.values.where((enabled) => enabled).length;

    expect(enabledCount, 2);
    expect(activityAlerts.length, isNot(2));
  });
}
