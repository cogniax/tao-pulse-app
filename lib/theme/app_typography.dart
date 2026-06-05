import 'package:flutter/material.dart';

import 'app_colors.dart';

class FigmaTypography {
  const FigmaTypography._();

  static const _clashDisplay = 'Clash Display';
  static const _figtree = 'Figtree';
  static const _sfCompactRounded = 'SF Compact Rounded';

  static const _bodyHeight = 1.4;

  static TextStyle _heading(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: _clashDisplay,
      fontSize: size,
      fontWeight: weight,
    );
  }

  static TextStyle _body(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: _figtree,
      fontSize: size,
      fontWeight: weight,
      height: _bodyHeight,
    );
  }

  static TextStyle _compact(double size, FontWeight weight) {
    return TextStyle(
      fontFamily: _sfCompactRounded,
      fontSize: size,
      fontWeight: weight,
    );
  }

  static TextStyle _caption(double size) {
    return TextStyle(
      fontFamily: _sfCompactRounded,
      fontSize: size,
      fontWeight: FontWeight.w500,
    );
  }

  // Headings
  static final h1Regular = _heading(36, FontWeight.w400);
  static final h1Semibold = _heading(36, FontWeight.w600);
  static final h2Regular = _heading(32, FontWeight.w400);
  static final h2Bold = _heading(32, FontWeight.w700);
  static final h3Regular = _heading(28, FontWeight.w400);
  static final h3Semibold = _heading(28, FontWeight.w600);
  static final h4Regular = _heading(25, FontWeight.w400);
  static final h4Semibold = _heading(25, FontWeight.w600);
  static final h5Regular = _heading(22, FontWeight.w400);
  static final h5Semibold = _heading(22, FontWeight.w600);
  static final h6Regular = _heading(20, FontWeight.w400);
  static final h6Semibold = _heading(20, FontWeight.w600);
  static final h7Regular = _heading(18, FontWeight.w400);
  static final h7Semibold = _heading(18, FontWeight.w600);
  static final h8Regular = _heading(16, FontWeight.w400);
  static final h8Medium = _heading(16, FontWeight.w500);

  // Body copy
  static final bodyLargeRegular = _body(18, FontWeight.w400);
  static final bodyLargeMedium = _body(18, FontWeight.w500);
  static final bodyLargeSemibold = _body(18, FontWeight.w600);

  static final bodyRegularRegular = _body(16, FontWeight.w400);
  static final bodyRegularMedium = _body(16, FontWeight.w500);
  static final bodyRegularSemibold = _body(16, FontWeight.w600);

  static final bodySmallRegular = _body(14, FontWeight.w400);
  static final bodySmallMedium = _body(14, FontWeight.w500);
  static final bodySmallSemibold = _body(14, FontWeight.w600);
  static final compactBodySmallRegular = _compact(14, FontWeight.w400);
  static final compactBodySmallMedium = _compact(14, FontWeight.w500);

  // Captions
  static final caption = _caption(12);
  static final footnote = _caption(10);
}

class AppTypography {
  static TextTheme textTheme = const TextTheme(
    displaySmall: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      height: 1.1,
      letterSpacing: -0.8,
      color: AppColors.textPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      height: 1.14,
      letterSpacing: -0.5,
      color: AppColors.textPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.2,
      color: AppColors.textPrimary,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.25,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textSecondary,
    ),
    bodyMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      height: 1.45,
      color: AppColors.textSecondary,
    ),
    bodySmall: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      height: 1.35,
      color: AppColors.textMuted,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: AppColors.textPrimary,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.25,
      color: AppColors.textMuted,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: AppColors.textMuted,
    ),
  );
}
