import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../theme/theme.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: FigmaColors.pageBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.pageHorizontal,
            AppSpacing.pageTop,
            AppSpacing.pageHorizontal,
            AppSpacing.xl + bottomInset,
          ),
          child: Column(
            children: [
              const Expanded(child: Center(child: _OnboardingTitle())),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => HomeRootRoute().go(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: FigmaColors.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.lg,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: FigmaTypography.bodyRegularSemibold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'TaoPulse',
      textAlign: TextAlign.center,
      style: FigmaTypography.h2Bold.copyWith(color: FigmaColors.brandPrimary),
    );
  }
}
