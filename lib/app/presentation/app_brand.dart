import 'dart:math' as math;

import 'package:flutter/material.dart';

const appBrandName = 'Presense';
const appBrandSignature = 'by artisanco.de';

class AppBrandPalette {
  static const deepTeal = Color(0xFF0F6E56);
  static const richTeal = Color(0xFF1D9E75);
  static const mint = Color(0xFF9FE1CB);
  static const softMint = Color(0xFFE1F5EE);
  static const darkTeal = Color(0xFF085041);
  static const ink = Color(0xFF10231D);
  static const mist = Color(0xFFF4FAF7);
  static const night = Color(0xFF071511);
  static const nightSurface = Color(0xFF0D1F19);
  static const nightCard = Color(0xFF132821);
  static const nightOutline = Color(0xFF2A433B);
}

class PresenseMark extends StatelessWidget {
  const PresenseMark({
    this.size = 56,
    this.withBackground = true,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  final double size;
  final bool withBackground;
  final Color? backgroundColor;
  final Color? foregroundColor;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _PresenseMarkPainter(
          showBackground: withBackground,
          backgroundColor:
              backgroundColor ??
              (withBackground ? AppBrandPalette.deepTeal : Colors.transparent),
          foregroundColor: foregroundColor ?? colorScheme.onPrimary,
          ringColor: AppBrandPalette.mint,
          middleRingColor: AppBrandPalette.richTeal,
          centerColor: AppBrandPalette.softMint,
        ),
      ),
    );
  }
}

class PresenseWordmark extends StatelessWidget {
  const PresenseWordmark({this.style, super.key});

  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.w300,
      color: isDark ? Colors.white : AppBrandPalette.ink,
      letterSpacing: 0.6,
    );

    return RichText(
      text: TextSpan(
        style: defaultStyle?.merge(style),
        children: [
          const TextSpan(text: 'pres'),
          TextSpan(
            text: 'en',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: isDark ? AppBrandPalette.mint : AppBrandPalette.deepTeal,
            ),
          ),
          const TextSpan(text: 'se'),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class PresenseLockup extends StatelessWidget {
  const PresenseLockup({
    this.markSize = 56,
    this.spacing = 14,
    this.showSignature = true,
    this.wordmarkStyle,
    this.axis = Axis.horizontal,
    super.key,
  });

  final double markSize;
  final double spacing;
  final bool showSignature;
  final TextStyle? wordmarkStyle;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final signatureStyle = textTheme.labelSmall?.copyWith(
      color: Theme.of(context).colorScheme.onSurfaceVariant,
      letterSpacing: 1.0,
      fontWeight: FontWeight.w600,
    );

    final label = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: axis == Axis.horizontal
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        PresenseWordmark(style: wordmarkStyle),
        if (showSignature) ...[
          const SizedBox(height: 4),
          Text(appBrandSignature, style: signatureStyle),
        ],
      ],
    );

    if (axis == Axis.vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PresenseMark(size: markSize),
          SizedBox(height: spacing),
          label,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PresenseMark(size: markSize),
        SizedBox(width: spacing),
        Flexible(child: label),
      ],
    );
  }
}

class _PresenseMarkPainter extends CustomPainter {
  const _PresenseMarkPainter({
    required this.showBackground,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.ringColor,
    required this.middleRingColor,
    required this.centerColor,
  });

  final bool showBackground;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color ringColor;
  final Color middleRingColor;
  final Color centerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);

    if (showBackground) {
      final backgroundRect = RRect.fromRectAndRadius(
        Offset.zero & size,
        Radius.circular(shortestSide * 0.26),
      );
      final backgroundPaint = Paint()..color = backgroundColor;
      canvas.drawRRect(backgroundRect, backgroundPaint);
    }

    final outerRadius = shortestSide * 0.25;
    final middleRadius = shortestSide * 0.15;
    final coreRadius = shortestSide * 0.06;

    final outerPaint = Paint()
      ..color = ringColor
      ..strokeWidth = shortestSide * 0.028
      ..style = PaintingStyle.stroke;
    final middlePaint = Paint()
      ..color = middleRingColor
      ..strokeWidth = shortestSide * 0.022
      ..style = PaintingStyle.stroke;
    final corePaint = Paint()..color = centerColor;
    final arcPaint = Paint()
      ..color = foregroundColor
      ..strokeWidth = shortestSide * 0.024
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, outerRadius, outerPaint);
    canvas.drawCircle(center, middleRadius, middlePaint);
    canvas.drawCircle(center, coreRadius, corePaint);

    _drawDashedArc(
      canvas: canvas,
      rect: Rect.fromCircle(center: center, radius: outerRadius),
      startAngle: -math.pi / 2,
      sweepAngle: math.pi / 2,
      dashAngle: 0.16,
      gapAngle: 0.11,
      paint: arcPaint,
    );
  }

  void _drawDashedArc({
    required Canvas canvas,
    required Rect rect,
    required double startAngle,
    required double sweepAngle,
    required double dashAngle,
    required double gapAngle,
    required Paint paint,
  }) {
    var currentAngle = startAngle;
    final maxAngle = startAngle + sweepAngle;

    while (currentAngle < maxAngle) {
      final nextAngle = math.min(currentAngle + dashAngle, maxAngle);
      canvas.drawArc(
        rect,
        currentAngle,
        nextAngle - currentAngle,
        false,
        paint,
      );
      currentAngle = nextAngle + gapAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _PresenseMarkPainter oldDelegate) {
    return showBackground != oldDelegate.showBackground ||
        backgroundColor != oldDelegate.backgroundColor ||
        foregroundColor != oldDelegate.foregroundColor ||
        ringColor != oldDelegate.ringColor ||
        middleRingColor != oldDelegate.middleRingColor ||
        centerColor != oldDelegate.centerColor;
  }
}
