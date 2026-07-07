import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The TaoPulse radar mark: the logo with a continuously rotating sweep beam.
///
/// Self-contained — it drives its own looping sweep, so callers just drop it in.
/// The splash additionally wraps it in an intro fade/scale; the welcome screen
/// uses it as a static hero.
class TaoRadarMark extends StatefulWidget {
  const TaoRadarMark({this.size = 224, super.key});

  final double size;

  /// The mark asset (without a baked sweep). Exposed so screens can precache it.
  static const asset = 'assets/splash/logo_base.png';

  @override
  State<TaoRadarMark> createState() => _TaoRadarMarkState();
}

class _TaoRadarMarkState extends State<TaoRadarMark>
    with SingleTickerProviderStateMixin {
  static const _imageOpacity = 0.58; // dim the mark; the beam stays vivid

  late final AnimationController _sweep;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Opacity(
            opacity: _imageOpacity,
            child: Image(
              image: AssetImage(TaoRadarMark.asset),
              fit: BoxFit.contain,
            ),
          ),
          AnimatedBuilder(
            animation: _sweep,
            builder: (context, _) =>
                CustomPaint(painter: _RadarSweepPainter(_sweep.value)),
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
