import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Fondo decorativo con sakuras que flotan lentamente en la pantalla.
class SakuraBackground extends StatefulWidget {
  const SakuraBackground({super.key, this.opacity = .42});
  final double opacity;

  @override
  State<SakuraBackground> createState() => _SakuraBackgroundState();
}

class _SakuraBackgroundState extends State<SakuraBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 22),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) => CustomPaint(
              painter: _SakuraPainter(_controller.value, widget.opacity),
              size: Size.infinite,
            ),
          ),
        ),
      );
}

class _SakuraPainter extends CustomPainter {
  const _SakuraPainter(this.progress, this.opacity);
  final double progress;
  final double opacity;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [const Color(0xFFFF9EC4), const Color(0xFFB79CFF), const Color(0xFFFFC7DB)];
    for (var i = 0; i < 13; i++) {
      final seed = i * .6180339887;
      final x = (seed * size.width + math.sin(progress * math.pi * 2 + i) * 22) % size.width;
      final travel = (progress + seed) % 1;
      final y = travel * (size.height + 70) - 35;
      final rotation = progress * math.pi * 2 + i * .8;
      final radius = 5.0 + (i % 3) * 2;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);
      final paint = Paint()..color = colors[i % colors.length].withValues(alpha: opacity * (.65 + (i % 3) * .12));
      for (var petal = 0; petal < 5; petal++) {
        canvas.save();
        canvas.rotate(petal * math.pi * 2 / 5);
        canvas.drawOval(Rect.fromCenter(center: Offset(0, -radius), width: radius * .72, height: radius * 1.25), paint);
        canvas.restore();
      }
      canvas.drawCircle(Offset.zero, radius * .23, Paint()..color = Colors.white.withValues(alpha: opacity));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _SakuraPainter oldDelegate) => oldDelegate.progress != progress || oldDelegate.opacity != opacity;
}
