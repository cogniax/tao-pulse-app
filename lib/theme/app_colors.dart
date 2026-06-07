import 'package:flutter/material.dart';

class FigmaColors {
  const FigmaColors._();

  // Figma tokens
  // Surface
  static const pageBackground = Colors.black;
  static const neutralPrimary = Color(0xFF101010);
  static const neutralSecondary = Color(0xFF252426);
  static const neutralTertiary = Color(0xFF3B3B3D);
  static const neutralDisabled = Color(0xFF545356);

  static const neutralInversePrimary = Color(0xFFFFFFFF);
  static const neutralInverseSecondary = Color(0xFFE0DDE6);
  static const neutralInverseTertiary = Color(0xFFC9C7CF);

  static const brandPrimary = Color(0xFF8C58FB);
  static const brandSecondary = Color(0xFFFFEB3B);
  static const brandTertiary = Color(0xFFFF4500);

  // Surface semantic
  static const successSubtle = Color(0xFFE5FFF3);
  static const successBold = Color(0xFF00FF85);
  static const errorSubtle = Color(0xFFFFE5E5);
  static const errorBold = Color(0xFFFF0000);
  static const warningSubtle = Color(0xFFFFCBB7);
  static const warningBold = Color(0xFFFF4500);
  static const infoSubtle = Color(0xFFE8F4FF);
  static const infoBold = Color(0xFF0D76DD);

  // Text
  static const textNeutralPrimary = neutralInversePrimary;
  static const textNeutralSecondary = neutralInverseSecondary;
  static const textNeutralTertiary = neutralInverseTertiary;
  static const textNeutralDisabled = Color(0xFF828186);

  static const textNeutralInversePrimary = Color(0xFF6B6A6E);
  static const textNeutralInverseSecondary = neutralDisabled;
  static const textNeutralInverseTertiary = neutralSecondary;

  static const textBrandPrimary = Color(0xFFF3EEFF);
  static const textBrandSecondary = Color(0xFFFFFDEB);
  static const textBrandTertiary = textBrandSecondary;

  static const textSuccessSubtle = Color(0xFF00AD5B);
  static const textSuccessBold = Color(0xFF005C30);
  static const textErrorSubtle = Color(0xFFFF0000);
  static const textErrorBold = Color(0xFFFFE5E5);
  static const textWarningSubtle = Color(0xFFD63A00);
  static const textWarningBold = Color(0xFFFFECE5);
  static const textInfoSubtle = Color(0xFF004E99);
  static const textInfoBold = Color(0xFFE8F4FF);

  // Icon
  static const iconNeutralPrimary = textNeutralPrimary;
  static const iconNeutralSecondary = textNeutralSecondary;
  static const iconNeutralTertiary = textNeutralTertiary;
  static const iconNeutralDisabled = textNeutralDisabled;

  static const iconNeutralInversePrimary = textNeutralInversePrimary;
  static const iconNeutralInverseSecondary = textNeutralInverseSecondary;
  static const iconNeutralInverseTertiary = textNeutralInverseTertiary;

  static const iconBrandPrimary = textBrandPrimary;
  static const iconBrandSecondary = textBrandSecondary;
  static const iconBrandTertiary = textBrandTertiary;

  static const iconSuccessSubtle = textSuccessSubtle;
  static const iconSuccessBold = textSuccessBold;
  static const iconErrorSubtle = textErrorSubtle;
  static const iconErrorBold = textErrorBold;
  static const iconWarningSubtle = textWarningSubtle;
  static const iconWarningBold = textWarningBold;
  static const iconInfoSubtle = textInfoSubtle;
  static const iconInfoBold = textInfoBold;

  // Border
  static const borderNeutralInversePrimary = Color(0xFF3A3445);
  static const borderDefault = Color(0xFFD9D9D9);
}

class AppColors {
  const AppColors._();

  // Existing tokens for backward compatibility
  static const primary = Color(0xFF6F4BBC);
  static const primaryLight = Color(0xFF9B7FE8);
  static const primaryDark = Color(0xFF4E3190);

  static const bgPrimary = Color(0xFF090B10);
  static const bgSurface = Color(0xFF0B1023);
  static const bgCard = Color(0xFF11182D);
  static const bgHover = Color(0xFF161F3A);
  static const border = Color.fromRGBO(255, 255, 255, 0.06);

  static const success = Color(0xFF22C55E);
  static const warning = Color(0xFFF59E0B);
  static const critical = Color(0xFFEF4444);
  static const info = Color(0xFF3B82F6);

  static const surfaceSecondary = Color(0xFF161C28);
  static const surfaceCard = Color(0xFF161C28);
  static const surfaceHover = Color(0xFF161F3A);
  static const borderSubtle = Color(0x0FFFFFFF);

  static const brandStart = Color(0xFF7B5CFF);
  static const brandMid = Color(0xFFA855F7);
  static const brandEnd = Color(0xFF4F8CFF);
  static const aiPurple = Color(0xFF8B5CF6);

  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xB8FFFFFF);
  static const textMuted = Color(0x80FFFFFF);
  static const textDisabled = Color(0x52FFFFFF);

  static const navInactive = Color(0x8CFFFFFF);
  static const overlayDark = Color(0x59000000);
  static const glowPurple = Color(0x2E8B5CF6);
}
