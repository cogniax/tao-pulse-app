import 'package:flutter_test/flutter_test.dart';
import 'package:taopulse/core/format/tao_format.dart';

void main() {
  group('formatCompactTao', () {
    test('formats sub-thousand values', () {
      expect(formatCompactTao(0), '0');
      expect(formatCompactTao(42), '42');
      expect(formatCompactTao(42.5), '42.5');
    });

    test('formats thousands and millions', () {
      expect(formatCompactTao(1500), '1.5K');
      expect(formatCompactTao(12000), '12K');
      expect(formatCompactTao(1500000), '1.5M');
      expect(formatCompactTao(12500000), '13M');
    });

    test('formats billions and trillions (previously rendered as M)', () {
      expect(formatCompactTao(5000000000), '5.0B');
      expect(formatCompactTao(2300000000000), '2.3T');
    });

    test('rolls over at unit boundaries instead of showing 1000K', () {
      expect(formatCompactTao(999999), '1.0M');
      expect(formatCompactTao(999999999), '1.0B');
    });

    test('keeps the sign for negative values', () {
      expect(formatCompactTao(-1500000), '-1.5M');
    });
  });

  group('formatPreciseTao', () {
    test('uses more decimals for smaller magnitudes', () {
      expect(formatPreciseTao(12.345), '12.35');
      expect(formatPreciseTao(0.5), '0.500');
      expect(formatPreciseTao(0.0234), '0.0234');
    });

    test('handles negative values via magnitude', () {
      expect(formatPreciseTao(-2), '-2.00');
    });
  });
}
