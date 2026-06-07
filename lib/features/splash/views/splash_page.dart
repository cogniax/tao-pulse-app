import 'package:flutter/material.dart';

import '../../../app/app_router.dart';
import '../../../theme/theme.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      OnboardingRoute().go(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: FigmaColors.pageBackground,
      body: Center(child: _SplashTitle()),
    );
  }
}

class _SplashTitle extends StatelessWidget {
  const _SplashTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'TaoPulse',
      textAlign: TextAlign.center,
      style: FigmaTypography.h2Bold.copyWith(color: FigmaColors.brandPrimary),
    );
  }
}
