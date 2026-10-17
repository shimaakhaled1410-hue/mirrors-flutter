import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_routes.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';

/// Flutter splash that continues the native splash (same logo, same
/// position, same background) and then adds a shine, sparkles and the title.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _total = Duration(milliseconds: 2600);
  // Native splash draws the 1152px logo at 288 logical pixels.
  static const double _logoSize = 288;

  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;
  late final Animation<double> _shine;
  late final Animation<double> _title;
  late final Animation<double> _sparkle;
  late final Animation<double> _progress;

  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _total);

    // Starts at 1.0 so the first frame matches the native splash exactly.
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );
    _glow = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _shine = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.25, 0.65, curve: Curves.easeInOut),
    );
    _title = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.8, curve: Curves.easeOutCubic),
    );
    _sparkle = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 1.0),
    );
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (MediaQuery.disableAnimationsOf(context)) {
      // Respect the system "reduce motion" setting.
      _controller.value = 1;
      _goNext(const Duration(milliseconds: 700));
    } else {
      _controller.forward().whenComplete(
        () => _goNext(const Duration(milliseconds: 250)),
      );
    }
  }

  Future<void> _goNext(Duration wait) async {
    await Future.delayed(wait);
    if (!mounted) return;
    context.go(AppRoutes.mainLayout);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Follow the SYSTEM brightness (not the in-app theme) so this screen
    // matches the native splash, which is chosen by the system too.
    final isDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final bg = isDark ? AppColors.primary : AppColors.lightBackground;
    final glowColor = isDark ? AppColors.primaryLight : AppColors.accentSoft;
    final titleColor = isDark ? Colors.white : AppColors.primary;
    final subtitleColor = isDark ? AppColors.accentSoft : AppColors.accent;
    final sparkleColor = isDark ? Colors.white : AppColors.accent;
    final logoAsset = isDark
        ? 'assets/images/splash_logo.png'
        : 'assets/images/splash_logo_light.png';

    return Scaffold(
      backgroundColor: bg,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Stack(
            children: [
              // Soft light that fades in behind the logo.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.15),
                      radius: 0.95,
                      colors: [
                        glowColor.withValues(
                          alpha: (isDark ? 0.5 : 0.35) * _glow.value,
                        ),
                        bg,
                      ],
                    ),
                  ),
                ),
              ),

              // Logo: same asset as the native splash, plus shine and sparkles.
              Center(
                child: Transform.scale(
                  scale: _scale.value,
                  child: SizedBox(
                    width: _logoSize,
                    height: _logoSize,
                    child: Stack(
                      children: [
                        Image.asset(
                          logoAsset,
                          width: _logoSize,
                          height: _logoSize,
                          fit: BoxFit.contain,
                        ),
                        CustomPaint(
                          size: const Size.square(_logoSize),
                          painter: _ShinePainter(_shine.value),
                        ),
                        CustomPaint(
                          size: const Size.square(_logoSize),
                          painter: _SparklePainter(_sparkle.value, sparkleColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Title.
              Align(
                alignment: const Alignment(0, 0.42),
                child: Opacity(
                  opacity: _title.value,
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - _title.value)),
                    child: Text(
                      'SH&M Mirrors Store',
                      style: AppStyles.bold20(context).copyWith(
                        color: titleColor,
                        fontSize: 26,
                      ),
                    ),
                  ),
                ),
              ),

              // Thin progress line.
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Opacity(
                      opacity: _title.value,
                      child: SizedBox(
                        width: 96,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: _progress.value,
                            minHeight: 3,
                            backgroundColor: titleColor.withValues(alpha: 0.12),
                            valueColor: AlwaysStoppedAnimation(subtitleColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Same arch shape as the logo: semicircle on top, rounded corners below.
Path _archPath(Rect r, double bottomRadius) {
  final w = r.width;
  final p = Path()..moveTo(r.left, r.top + w / 2);
  p.arcTo(Rect.fromLTWH(r.left, r.top, w, w), math.pi, math.pi, false);
  p.lineTo(r.right, r.bottom - bottomRadius);
  p.arcToPoint(
    Offset(r.right - bottomRadius, r.bottom),
    radius: Radius.circular(bottomRadius),
  );
  p.lineTo(r.left + bottomRadius, r.bottom);
  p.arcToPoint(
    Offset(r.left, r.bottom - bottomRadius),
    radius: Radius.circular(bottomRadius),
  );
  p.close();
  return p;
}

/// A bright band that sweeps across the mirror glass once.
class _ShinePainter extends CustomPainter {
  final double progress;
  _ShinePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    // Geometry mirrors how splash_logo.png was drawn (fractions of the canvas).
    final s = size.width;
    final w = s * 0.385;
    final h = s * 0.54;
    final x0 = (s - w) / 2;
    final y0 = (s - h) / 2;
    final t = w * 0.065;
    final rb = w * 0.14;

    final glass = Rect.fromLTRB(x0 + t, y0 + t, x0 + w - t, y0 + h - t);
    canvas.save();
    canvas.clipPath(_archPath(glass, rb - t));

    final gw = glass.width;
    final gh = glass.height;
    final shear = gh * 0.55;
    final bw = gw * 0.34;

    final startX = glass.left - shear - bw;
    final endX = glass.right + bw;
    final cx = startX + (endX - startX) * progress;

    final band = Path()
      ..moveTo(cx - bw / 2, glass.bottom)
      ..lineTo(cx + bw / 2, glass.bottom)
      ..lineTo(cx + bw / 2 + shear, glass.top)
      ..lineTo(cx - bw / 2 + shear, glass.top)
      ..close();

    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.7)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, s * 0.012);
    canvas.drawPath(band, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ShinePainter old) => old.progress != progress;
}

/// Three small four-point stars that twinkle around the mirror.
class _SparklePainter extends CustomPainter {
  final double t;
  final Color color;
  _SparklePainter(this.t, this.color);

  // (x, y) as fractions of the logo box, radius in logical px, start delay.
  static const _sparkles = [
    (0.26, 0.30, 11.0, 0.00),
    (0.75, 0.23, 8.0, 0.18),
    (0.73, 0.79, 6.5, 0.34),
  ];

  Path _star(Offset c, double r) {
    return Path()
      ..moveTo(c.dx, c.dy - r)
      ..quadraticBezierTo(c.dx, c.dy, c.dx + r, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy + r)
      ..quadraticBezierTo(c.dx, c.dy, c.dx - r, c.dy)
      ..quadraticBezierTo(c.dx, c.dy, c.dx, c.dy - r)
      ..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final (fx, fy, radius, delay) in _sparkles) {
      final local = ((t - delay) / 0.45).clamp(0.0, 1.0);
      if (local <= 0 || local >= 1) continue;
      final intensity = math.sin(local * math.pi);
      final center = Offset(size.width * fx, size.height * fy);
      final paint = Paint()
        ..color = color.withValues(alpha: 0.9 * intensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.6);
      canvas.drawPath(_star(center, radius * intensity), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SparklePainter old) =>
      old.t != t || old.color != color;
}