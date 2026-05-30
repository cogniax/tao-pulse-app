import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/features/settings/domain/text_format.dart';

void main() {
  group('titleCase', () {
    test('capitalizes the first character', () {
      expect(titleCase('balanced'), 'Balanced');
    });

    test('leaves the remainder of the string unchanged', () {
      expect(titleCase('aI insight'), 'AI insight');
    });

    test('returns an empty string unchanged', () {
      expect(titleCase(''), '');
    });

    test('leaves an already-capitalized value unchanged', () {
      expect(titleCase('System'), 'System');
    });
  });
}
