import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../../../app/app_router.dart';
import '../../../theme/theme.dart';

/// Splash sequence:
///  1. Opens on the "TaoPulse" wordmark, centered — identical to the native
///     splash, so the hand-off is seamless (no size drift, no flash).
///  2. The wordmark glides smoothly up to the top.
///  3. The radar logo fades + scales in below it, dimmed so the bright sweeping
///     beam reads as the focal point.
///  4. The beam scans the subnet field until we route to onboarding.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  static const _logoSize = 224.0;
  static const _logoAlignment = Alignment(0, -0.18); // tucked under the wordmark
  static const _wordTopAlignment = Alignment(0, -0.72);
  static const _logoImageOpacity = 0.58; // dim the mark; the beam stays vivid
  static const _assetLogo = 'assets/splash/logo_base.png';

  late final AnimationController _intro;
  late final AnimationController _sweep;

  late final Animation<Alignment> _wordAlign;
  late final Animation<double> _logoReveal;
  late final Animation<double> _logoScale;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    // Slow, smooth glide from center to the top.
    _wordAlign = AlignmentTween(
      begin: Alignment.center,
      end: _wordTopAlignment,
    ).animate(
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // First frame is drawn (wordmark centered) — release the native splash
      // and start the sequence.
      FlutterNativeSplash.remove();
      _intro.forward();
    });

    Future<void>.delayed(const Duration(milliseconds: 3800), () {
      if (!mounted) return;
      OnboardingRoute().go(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Decode the logo before it fades in so there's no pop on first paint.
    precacheImage(const AssetImage(_assetLogo), context);
  }

  @override
  void dispose() {
    _intro.dispose();
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FigmaColors.pageBackground,
      body: Stack(
        children: [
          // Radar logo + live sweep beam, tucked under the wordmark.
          Align(
            alignment: _logoAlignment,
            child: FadeTransition(
              opacity: _logoReveal,
              child: ScaleTransition(
                scale: _logoScale,
                child: SizedBox(
                  width: _logoSize,
                  height: _logoSize,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      const Opacity(
                        opacity: _logoImageOpacity,
                        child: Image(
                          image: AssetImage(_assetLogo),
                          fit: BoxFit.contain,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _sweep,
                        builder: (context, _) => CustomPaint(
                          painter: _RadarSweepPainter(_sweep.value),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Wordmark — starts centered (matches native), glides to the top.
          AnimatedBuilder(
            animation: _wordAlign,
            builder: (context, child) => Align(
              alignment: _wordAlign.value,
              child: child,
            ),
            child: Text(
              'TaoPulse',
              textAlign: TextAlign.center,
              style: FigmaTypography.h2Bold.copyWith(
                color: FigmaColors.brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A rotating radar beam drawn over the logo. Additive blending makes it read as
/// a bright light sweeping across the dimmed rings.
class _RadarSweepPainter extends CustomPainter {
  _RadarSweepPainter(this.t);

  /// Rotation phase, 0..1.
  final double t;

  static const _lavender = Color(0xFFCEB6FF);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * 0.5 * 0.80; // stay within the outer ring
    final rect = Rect.fromCircle(center: center, radius: radius);

    final beam = Paint()
      ..blendMode = BlendMode.plus
      ..shader = SweepGradient(
        transform: GradientRotation(t * 2 * math.pi),
        colors: const [
          Color(0x00B794FF),
          Color(0x00B794FF),
          Color(0x338C58FB),
          Color(0x948C58FB),
          Color(0xFFCEB6FF),
          Color(0x00B794FF),
        ],
        stops: const [0.0, 0.48, 0.74, 0.90, 0.99, 1.0],
      ).createShader(rect);

    canvas.save();
    canvas.clipPath(Path()..addOval(rect));
    canvas.drawCircle(center, radius, beam);

    // Bright leading edge of the beam.
    final angle = t * 2 * math.pi;
    final tip = center + Offset(math.cos(angle), math.sin(angle)) * radius;
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..blendMode = BlendMode.plus
        ..color = _lavender
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RadarSweepPainter oldDelegate) => oldDelegate.t != t;
}
