import 'dart:math';
import 'package:flutter/material.dart';

class AppLoadingIndicator extends StatefulWidget {
  final double size;
  final double strokeWidth;

  const AppLoadingIndicator({
    super.key,
    required this.size,
    required this.strokeWidth,
  });

  @override
  State<AppLoadingIndicator> createState() => _AppLoadingIndicatorState();
}

class _AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return CustomPaint(
          size: Size.square(widget.size),
          painter: _LoadingPainter(
            strokeWidth: widget.strokeWidth,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _LoadingPainter extends CustomPainter {
  final double strokeWidth;
  final double progress;

  _LoadingPainter({required this.strokeWidth, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - strokeWidth / 2;

    final sweepGradient = SweepGradient(
      colors: const [Colors.white, Colors.white70, Colors.transparent],
      stops: const [0.0, 0.5, 0.85],
      transform: GradientRotation(-2 * pi * progress),
    );

    final arcPaint = Paint()
      ..shader = sweepGradient.createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, arcPaint);

    final angle = -2 * pi * progress;

    final ballOffset = Offset(
      center.dx + radius * cos(angle),
      center.dy + radius * sin(angle),
    );

    final ballPaint = Paint()..color = Colors.white;

    canvas.drawCircle(ballOffset, strokeWidth / 2, ballPaint);
  }

  @override
  bool shouldRepaint(covariant _LoadingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
