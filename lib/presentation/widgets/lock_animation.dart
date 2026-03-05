// lib/presentation/widgets/padlock_biometric_animation.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PadlockBiometricAnimation extends StatefulWidget {
  const PadlockBiometricAnimation({Key? key}) : super(key: key);

  @override
  State<PadlockBiometricAnimation> createState() =>
      _PadlockBiometricAnimationState();
}

class _PadlockBiometricAnimationState extends State<PadlockBiometricAnimation>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _keyController;
  late AnimationController _shackleController;
  late AnimationController _glowController;
  late AnimationController _scanController;

  // Animation progress values
  late Animation<double> _keySlideProgress;
  late Animation<double> _keyRotateProgress;
  late Animation<double> _keyFadeProgress;
  late Animation<double> _shackleProgress;
  late Animation<double> _glowProgress;
  late Animation<double> _scanProgress;

  // Animation timing constants (in milliseconds)
  static const int _initialDelay = 400;
  static const int _keySlideDuration = 1260; // 45% of 2800
  static const int _keyRotateDuration = 560; // 20% of 2800
  static const int _keyFadeDuration = 280; // 10% of 2800
  static const int _totalKeyDuration = 2800;
  static const int _shackleDuration = 600;
  static const int _glowDuration = 1200;
  static const int _scanDuration = 1800;
  static const int _scanStartDelay = 1300;
  static const int _shackleStartDelay = 2200; // 1300 + 900
  static const int _resetDelay = 3600; // 2200 + 1400
  static const int _pauseBetweenCycles = 600;

  @override
  void initState() {
    super.initState();

    // Key movement controller
    _keyController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _totalKeyDuration),
    );

    // Shackle (lock arc) controller
    _shackleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _shackleDuration),
    );

    // Glow/pulse controller
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _glowDuration),
    )..repeat(reverse: true);

    // Scan line controller
    _scanController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _scanDuration),
    );

    // Key slide from right into keyhole (progress 0 to 1)
    _keySlideProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _keyController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeInOut),
    ));

    // Key rotates once inserted (progress 0 to 1)
    _keyRotateProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _keyController,
      curve: const Interval(0.45, 0.65, curve: Curves.easeInOut),
    ));

    // Key fades out after unlock (progress 0 to 1)
    _keyFadeProgress = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _keyController,
      curve: const Interval(0.65, 0.75, curve: Curves.easeOut),
    ));

    // Scan animation (progress 0 to 1)
    _scanProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scanController,
        curve: Curves.easeInOut,
      ),
    );

    // Shackle opens up (progress 0 to 1)
    _shackleProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shackleController, curve: Curves.elasticOut),
    );

    // Glow pulse (progress 0.3 to 1.0)
    _glowProgress = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Start the animation sequence
    _startSequence();
  }

  Future<void> _startSequence() async {
    if (!mounted) return;

    await Future.delayed(Duration(milliseconds: _initialDelay));
    if (!mounted) return;

    _keyController.forward();

    // Start scan after key is inserted
    await Future.delayed(Duration(milliseconds: _scanStartDelay));
    if (!mounted) return;

    _scanController.forward();

    // Open shackle after rotation
    await Future.delayed(Duration(milliseconds: _shackleStartDelay - _scanStartDelay));
    if (!mounted) return;

    _shackleController.forward();

    // Restart loop
    await Future.delayed(Duration(milliseconds: _resetDelay - _shackleStartDelay));
    if (!mounted) return;

    _resetAndReplay();
  }

  Future<void> _resetAndReplay() async {
    if (!mounted) return;

    _keyController.reset();
    _shackleController.reset();
    _scanController.reset();

    await Future.delayed(Duration(milliseconds: _pauseBetweenCycles));
    if (!mounted) return;

    _startSequence();
  }

  @override
  void dispose() {
    _keyController.dispose();
    _shackleController.dispose();
    _glowController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _keyController,
          _shackleController,
          _glowController,
          _scanController,
        ]),
        builder: (context, child) {
          return CustomPaint(
            painter: _PadlockKeyPainter(
              keySlideProgress: _keySlideProgress.value,
              keyRotateProgress: _keyRotateProgress.value,
              keyOpacity: _keyFadeProgress.value,
              shackleOpen: _shackleProgress.value,
              glowIntensity: _glowProgress.value,
              scanProgress: _scanProgress.value,
              primaryColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}

class _PadlockKeyPainter extends CustomPainter {
  final double keySlideProgress;
  final double keyRotateProgress;
  final double keyOpacity;
  final double shackleOpen;
  final double glowIntensity;
  final double scanProgress;
  final Color primaryColor;

  // Drawing constants
  static const double _lockWidth = 58.0;
  static const double _lockHeight = 48.0;
  static const double _lockVerticalOffset = 16.0;
  static const double _keyholeXOffset = 0.0;
  static const double _keyholeYOffset = 12.0;
  static const double _shackleStrokeWidth = 7.0;
  static const double _shackleHorizontalOffset = 16.0;
  static const double _shackleBaseYOffset = -4.0;
  static const double _shackleTopYOffset = -14.0;
  static const double _keyBowRadius = 8.0;
  static const double _keyShaftLength = 28.0;
  static const double _keyShaftWidth = 6.0;
  static const double _keyStartOffsetX = 60.0; // Pixels to the right of keyhole
  static const double _keyStartOffsetY = -8.0; // Pixels above keyhole

  _PadlockKeyPainter({
    required this.keySlideProgress,
    required this.keyRotateProgress,
    required this.keyOpacity,
    required this.shackleOpen,
    required this.glowIntensity,
    required this.scanProgress,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Paint in correct order (back to front)
    _drawGlow(canvas, cx, cy, size);
    _drawLockBody(canvas, cx, cy, size);
    _drawShackle(canvas, cx, cy, size);
    _drawKeyhole(canvas, cx, cy);
    _drawScanLine(canvas, cx, cy, size);
    _drawKey(canvas, cx, cy, size);
  }

  void _drawGlow(Canvas canvas, double cx, double cy, Size size) {
    final glowPaint = Paint()
      ..color = primaryColor.withOpacity(0.12 * glowIntensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    canvas.drawCircle(
      Offset(cx, cy + 14),
      38 * glowIntensity,
      glowPaint,
    );
  }

  void _drawLockBody(Canvas canvas, double cx, double cy, Size size) {
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(cx, cy + _lockVerticalOffset),
          width: _lockWidth,
          height: _lockHeight
      ),
      const Radius.circular(10),
    );

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx, cy + _lockVerticalOffset + 4),
            width: _lockWidth,
            height: _lockHeight
        ),
        const Radius.circular(10),
      ),
      shadowPaint,
    );

    // Body fill
    final bodyPaint = Paint()..color = primaryColor;
    canvas.drawRRect(bodyRect, bodyPaint);

    // Shine overlay
    final shinePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.18),
          Colors.transparent,
        ],
      ).createShader(bodyRect.outerRect);
    canvas.drawRRect(bodyRect, shinePaint);

    // Border
    final borderPaint = Paint()
      ..color = primaryColor.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(bodyRect, borderPaint);
  }

  void _drawShackle(Canvas canvas, double cx, double cy, Size size) {
    final shacklePaint = Paint()
      ..color = primaryColor.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _shackleStrokeWidth
      ..strokeCap = StrokeCap.round;

    // Clamp shackleOpen value to valid range
    final openProgress = shackleOpen.clamp(0.0, 1.0);

    // Left vertical - stays in place
    canvas.drawLine(
      Offset(cx - _shackleHorizontalOffset, cy + _shackleBaseYOffset),
      Offset(cx - _shackleHorizontalOffset, cy + _shackleTopYOffset),
      shacklePaint,
    );

    // Right vertical - rises when open
    final rightVerticalLift = openProgress * 22.0;
    final rightTopY = cy + _shackleTopYOffset - rightVerticalLift;

    canvas.drawLine(
      Offset(cx + _shackleHorizontalOffset, cy + _shackleBaseYOffset),
      Offset(cx + _shackleHorizontalOffset, rightTopY),
      shacklePaint,
    );

    // Arc on top
    if (openProgress < 0.5) {
      // Arc stays connected
      final arcRect = Rect.fromCenter(
        center: Offset(cx, cy + _shackleTopYOffset),
        width: _shackleHorizontalOffset * 2,
        height: 20,
      );
      canvas.drawArc(arcRect, math.pi, math.pi, false, shacklePaint);
    } else {
      // Arc lifts and tilts as shackle opens
      final liftAmount = (openProgress - 0.5) * 2 * 10;
      final tiltAmount = (openProgress - 0.5) * 2 * 4;

      final arcRect = Rect.fromCenter(
        center: Offset(cx - 2 - tiltAmount, cy + _shackleTopYOffset - liftAmount),
        width: _shackleHorizontalOffset * 2,
        height: 20 + liftAmount,
      );
      canvas.drawArc(arcRect, math.pi, math.pi, false, shacklePaint);
    }
  }

  void _drawKeyhole(Canvas canvas, double cx, double cy) {
    final holeCenter = Offset(cx + _keyholeXOffset, cy + _keyholeYOffset);

    // Circle top of keyhole
    final holePaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawCircle(holeCenter, 7, holePaint);

    // Rectangle slot
    final slotPaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(cx + _keyholeXOffset, cy + _keyholeYOffset + 10),
            width: 5,
            height: 10
        ),
        const Radius.circular(2),
      ),
      slotPaint,
    );
  }

  void _drawScanLine(Canvas canvas, double cx, double cy, Size size) {
    if (scanProgress <= 0 || scanProgress >= 1) return;

    final bodyTop = cy + _lockVerticalOffset - _lockHeight / 2;
    final scanY = bodyTop + (scanProgress * _lockHeight);

    final bodyRect = Rect.fromCenter(
      center: Offset(cx, cy + _lockVerticalOffset),
      width: _lockWidth,
      height: _lockHeight,
    );

    canvas.save();
    canvas.clipRect(bodyRect);

    final scanPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.white.withOpacity(0.55),
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromLTWH(
          cx - _lockWidth / 2,
          scanY - 8,
          _lockWidth,
          16
      ));

    canvas.drawRect(
        Rect.fromLTWH(cx - _lockWidth / 2, scanY - 8, _lockWidth, 16),
        scanPaint
    );
    canvas.restore();
  }

  void _drawKey(Canvas canvas, double cx, double cy, Size size) {
    if (keyOpacity <= 0) return;

    // Keyhole position (final destination)
    final keyholeX = cx + _keyholeXOffset;
    final keyholeY = cy + _keyholeYOffset;

    // Starting position (far right and slightly above keyhole)
    final startX = keyholeX + _keyStartOffsetX;
    final startY = keyholeY + _keyStartOffsetY;

    // Interpolate key position based on slide progress
    final keyX = startX + (keyholeX - startX) * keySlideProgress;
    final keyY = startY + (keyholeY - startY) * keySlideProgress;

    // Calculate rotation angle (90 degrees max)
    final rotationAngle = keyRotateProgress * (math.pi / 2);

    canvas.save();
    canvas.translate(keyX, keyY);
    canvas.rotate(rotationAngle);

    final keyPaint = Paint()
      ..color = Colors.amber.shade600.withOpacity(keyOpacity)
      ..style = PaintingStyle.fill;

    final keyStrokePaint = Paint()
      ..color = Colors.amber.shade800.withOpacity(keyOpacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Key bow (ring) - positioned behind the shaft
    canvas.drawCircle(Offset(-20, 0), _keyBowRadius, keyPaint);
    canvas.drawCircle(Offset(-20, 0), _keyBowRadius, keyStrokePaint);

    // Inner hole of key bow
    final holePaint = Paint()..color = Colors.white.withOpacity(keyOpacity);
    canvas.drawCircle(Offset(-20, 0), 4, holePaint);

    // Key shaft
    final shaftPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(-12, -_keyShaftWidth/2, _keyShaftLength, _keyShaftWidth),
        const Radius.circular(3),
      ));
    canvas.drawPath(shaftPath, keyPaint);
    canvas.drawPath(shaftPath, keyStrokePaint);

    // Key teeth - only visible when key is not fully inserted
    if (keySlideProgress < 0.95) {
      final teethPaint = Paint()
        ..color = Colors.amber.shade600.withOpacity(keyOpacity);

      // Tooth 1
      canvas.drawRect(Rect.fromLTWH(2, -_keyShaftWidth/2 - 3, 4, 6), teethPaint);
      canvas.drawRect(Rect.fromLTWH(2, -_keyShaftWidth/2 - 3, 4, 6), keyStrokePaint);

      // Tooth 2
      canvas.drawRect(Rect.fromLTWH(10, -_keyShaftWidth/2 - 3, 4, 8), teethPaint);
      canvas.drawRect(Rect.fromLTWH(10, -_keyShaftWidth/2 - 3, 4, 8), keyStrokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_PadlockKeyPainter oldDelegate) {
    return oldDelegate.keySlideProgress != keySlideProgress ||
        oldDelegate.keyRotateProgress != keyRotateProgress ||
        oldDelegate.keyOpacity != keyOpacity ||
        oldDelegate.shackleOpen != shackleOpen ||
        oldDelegate.glowIntensity != glowIntensity ||
        oldDelegate.scanProgress != scanProgress ||
        oldDelegate.primaryColor != primaryColor;
  }
}