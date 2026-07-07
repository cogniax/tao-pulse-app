import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_router.dart';
import '../../../constants/local_preference_keys.dart';
import '../../../services/shared_preferences_provider.dart';
import '../../../theme/theme.dart';
import '../../../widgets/tao_radar_mark.dart';
import '../view_models/splash_notifier.dart';
import '../widgets/splash_wordmark.dart';

/// Splash sequence:
///  1. Opens on the "TaoPulse" wordmark, centered to match the native splash.
///  2. The wordmark glides up.
///  3. The radar mark fades and scales in below it.
///  4. Once the minimum hold completes, the page either routes away or reveals
///     the inline first-run welcome content.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _minSplashDuration = Duration(milliseconds: 3800);
  static const _logoSize = 224.0;
  static const _logoAlignment = Alignment(0, -0.18);
  static const _wordTopAlignment = Alignment(0, -0.72);

  late final AnimationController _intro;
  late final Animation<Alignment> _wordAlign;
  late final Animation<double> _logoReveal;
  late final Animation<double> _logoScale;

  bool _showWelcome = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
      _intro.forward();
    });

    _resolveSplashFlow();
  }

  void _setupAnimations() {
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _wordAlign = AlignmentTween(begin: Alignment.center, end: _wordTopAlignment)
        .animate(
          CurvedAnimation(
            parent: _intro,
            curve: const Interval(0.05, 0.80, curve: Curves.easeInOutCubic),
          ),
        );

    _logoReveal = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.28, 0.85, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.28, 0.92, curve: Curves.easeOutCubic),
      ),
    );
  }

  Future<void> _resolveSplashFlow() async {
    final destinationFuture = ref.read(splashProvider.future);
    await Future<void>.delayed(_minSplashDuration);
    final destination = await destinationFuture;
    if (!mounted) {
      return;
    }

    switch (destination) {
      case SplashDestination.home:
        HomeRootRoute().go(context);
      case SplashDestination.login:
        LoginRoute().go(context);
      case SplashDestination.welcome:
        setState(() => _showWelcome = true);
    }
  }

  Future<void> _handleGetStarted() async {
    try {
      await ref
          .read(sharedPreferencesProvider)
          .setBool(LocalPreferenceKeys.hasSeenWelcome, true);
    } finally {
      if (mounted) {
        LoginRoute().go(context);
      }
    }
  }

  void _openTerms() {
    // TODO: open the Terms of Service (external URL or in-app page).
  }

  void _openPrivacy() {
    // TODO: open the Privacy Policy (external URL or in-app page).
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(TaoRadarMark.asset), context);
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.pageBackground,
      body: Stack(
        children: [
          Align(
            alignment: _logoAlignment,
            child: FadeTransition(
              opacity: _logoReveal,
              child: ScaleTransition(
                scale: _logoScale,
                child: const TaoRadarMark(size: _logoSize),
              ),
            ),
          ),
          SplashWordmark(alignment: _wordAlign),
          _WelcomePanel(
            visible: _showWelcome,
            onGetStarted: _handleGetStarted,
            onOpenTerms: _openTerms,
            onOpenPrivacy: _openPrivacy,
          ),
        ],
      ),
    );
  }
}

class _WelcomePanel extends StatefulWidget {
  const _WelcomePanel({
    required this.visible,
    required this.onGetStarted,
    required this.onOpenTerms,
    required this.onOpenPrivacy,
  });

  final bool visible;
  final VoidCallback onGetStarted;
  final VoidCallback onOpenTerms;
  final VoidCallback onOpenPrivacy;

  @override
  State<_WelcomePanel> createState() => _WelcomePanelState();
}

class _WelcomePanelState extends State<_WelcomePanel> {
  late final TapGestureRecognizer _termsTap;
  late final TapGestureRecognizer _privacyTap;

  @override
  void initState() {
    super.initState();
    _termsTap = TapGestureRecognizer()..onTap = () => widget.onOpenTerms();
    _privacyTap = TapGestureRecognizer()..onTap = () => widget.onOpenPrivacy();
  }

  @override
  void dispose() {
    _termsTap.dispose();
    _privacyTap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linkStyle = FigmaTypography.bodySmallRegular.copyWith(
      color: FigmaColors.brandPrimary,
      height: 1.5,
      decoration: TextDecoration.underline,
      decorationColor: FigmaColors.brandPrimary,
    );

    return IgnorePointer(
      ignoring: !widget.visible,
      child: AnimatedOpacity(
        opacity: widget.visible ? 1 : 0,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageHorizontal,
              0,
              AppSpacing.pageHorizontal,
              AppSpacing.xl,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome to the Pulse.\n'
                      'Your Bittensor network,\n'
                      'at a glance.',
                      textAlign: TextAlign.center,
                      style: FigmaTypography.h5Semibold.copyWith(
                        color: FigmaColors.textNeutralPrimary,
                        height: 1.18,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Bittensor, live.',
                      textAlign: TextAlign.center,
                      style: FigmaTypography.bodyRegularRegular.copyWith(
                        color: FigmaColors.textNeutralSecondary,
                      ),
                    ),
                    const SizedBox(height: 36),
                    FilledButton(
                      onPressed: widget.onGetStarted,
                      style: FilledButton.styleFrom(
                        backgroundColor: FigmaColors.brandPrimary,
                        foregroundColor: FigmaColors.neutralPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: const StadiumBorder(),
                        textStyle: FigmaTypography.bodyRegularSemibold,
                      ),
                      child: const Text('Get Started'),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to our ',
                        children: [
                          TextSpan(
                            text: 'Terms',
                            style: linkStyle,
                            recognizer: _termsTap,
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: linkStyle,
                            recognizer: _privacyTap,
                          ),
                          const TextSpan(text: '.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: FigmaTypography.bodySmallRegular.copyWith(
                        color: FigmaColors.textNeutralSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
