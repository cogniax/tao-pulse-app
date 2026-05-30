import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/features/subnets/domain/tao_format.dart';

void main() {
  group('formatCompactTao', () {
    test('formats values in the millions with M suffix', () {
      expect(formatCompactTao(1200000), '1.2M');
    });

    test('drops the decimal for values at or above ten million', () {
      expect(formatCompactTao(12000000), '12M');
    });

    test('formats values in the thousands with K suffix', () {
      expect(formatCompactTao(3400), '3.4K');
    });

    test('drops the decimal for values at or above ten thousand', () {
      expect(formatCompactTao(15000), '15K');
    });

    test('renders whole numbers without a decimal', () {
      expect(formatCompactTao(42), '42');
    });

    test('renders fractional numbers with one decimal', () {
      expect(formatCompactTao(42.5), '42.5');
    });

    test('handles negative values using magnitude for suffix selection', () {
      expect(formatCompactTao(-1200000), '-1.2M');
      expect(formatCompactTao(-3400), '-3.4K');
    });

    test('zero renders as 0', () {
      expect(formatCompactTao(0), '0');
    });
  });
}
