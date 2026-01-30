import 'dart:math';
import 'package:flutter/material.dart';
import 'package:blood_donation_app/theme/app_theme.dart';

import 'custom_text.dart';

class CustomArcSlider extends StatefulWidget {
  final int initialValue;
  final int maxValue;

  const CustomArcSlider({
    super.key,
    this.initialValue = 1,
    required this.maxValue,
  });

  @override
  State<CustomArcSlider> createState() => _CustomArcSliderState();
}

class _CustomArcSliderState extends State<CustomArcSlider> {
  late int _currentValue;

  // Constants for styling
  final Color _activeColor = AppColors.textSecondary; // Green
  final Color _inactiveColor = AppColors.indicatorColor; // Light Grey
  final double _arcStrokeWidth = 8.0;
  final double _thumbRadius = 12.0;
  final double _centerCircleRadius = 40.0;
  final int minValue = 1;

  int get maxValue => widget.maxValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomArcSlider oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      setState(() {
        _currentValue = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double rawDiameter = min(constraints.maxWidth, constraints.maxHeight);
        final double diameter = rawDiameter.clamp(140.0, double.infinity);
        return Center(
          child: SizedBox(
            width: diameter - 70,
            height: diameter * 0.7, // Adjust height to fit the arc comfortably
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Custom Painter for the Arc and Thumb
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ArcSliderPainter(
                      minValue: minValue,
                      maxValue: maxValue,
                      currentValue: _currentValue,
                      activeColor: _activeColor,
                      inactiveColor: _inactiveColor,
                      arcStrokeWidth: _arcStrokeWidth,
                      thumbRadius: _thumbRadius,
                    ),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        final RenderBox renderBox =
                            context.findRenderObject() as RenderBox;
                        final Offset localPosition = renderBox.globalToLocal(
                          details.globalPosition,
                        );

                        // Calculate angle based on touch position
                        final Offset center = Offset(
                          diameter / 2,
                          diameter * 0.7 - _arcStrokeWidth,
                        ); // Adjusted center for bottom aligned arc
                        final double dx = localPosition.dx - center.dx;
                        final double dy = localPosition.dy - center.dy;

                        // Calculate angle in radians from the positive x-axis
                        double angle = atan2(dy, dx);

                        // Normalize angle to be between 0 and 180 degrees (pi radians) for the arc
                        // Our arc goes from -225 deg (-5pi/4) to 45 deg (pi/4)
                        // A full circle is 2PI. Our arc is 270 degrees.
                        // The starting point for drawing is 225 degrees (5 * pi / 4)
                        // The sweeping angle is 270 degrees (3 * pi / 2)
                        // We are interested in the angle relative to the start of the arc.
                        const double startAngleRad = 5 * pi / 4; // 225 degrees
                        const double sweepAngleRad = 3 * pi / 2; // 270 degrees

                        // Adjust angle to be relative to the start of the arc
                        // Angle from atan2 is in [-pi, pi].
                        // Convert to [0, 2pi]
                        if (angle < 0) {
                          angle += 2 * pi;
                        }

                        // Calculate progress based on angle
                        double normalizedAngle;
                        if (angle >= startAngleRad) {
                          normalizedAngle = angle - startAngleRad;
                        } else {
                          normalizedAngle = angle + (2 * pi - startAngleRad);
                        }

                        double progress = normalizedAngle / sweepAngleRad;
                        if (progress < 0) progress = 0;
                        if (progress > 1) progress = 1;
                      },
                    ),
                  ),
                ),

                // Min/Max Value Text
                Positioned(
                  left: 7,
                  bottom: diameter * 0.12 - _arcStrokeWidth * 1.5,
                  // Adjust positioning
                  child: CustomText(
                    minValue.toString().padLeft(2, '0'),
                    style: AppTextTheme.bodyLarge,
                  ),
                ),
                Positioned(
                  right: 7,
                  bottom: diameter * 0.12 - _arcStrokeWidth * 1.5,
                  // Adjust positioning
                  child: CustomText(
                    maxValue.toString().padLeft(2, '0'),
                    style: AppTextTheme.bodyLarge,
                  ),
                ),

                // Center Value Display
                Positioned(
                  bottom:
                      diameter * 0.4 / 2 -
                      _centerCircleRadius / 2 -
                      _arcStrokeWidth, // Center aligned with arc bottom
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _activeColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: CustomText(
                        _currentValue.toString().padLeft(2, '0'),
                        style: AppTextTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArcSliderPainter extends CustomPainter {
  final int minValue;
  final int maxValue;
  final int currentValue;
  final Color activeColor;
  final Color inactiveColor;
  final double arcStrokeWidth;
  final double thumbRadius;

  _ArcSliderPainter({
    required this.minValue,
    required this.maxValue,
    required this.currentValue,
    required this.activeColor,
    required this.inactiveColor,
    required this.arcStrokeWidth,
    required this.thumbRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius =
        min(size.width, size.height) / 1.7 - arcStrokeWidth / 2;
    final Offset center = Offset(
      size.width / 2,
      size.height - arcStrokeWidth / 2,
    ); // Adjusted center for bottom aligned arc

    final Paint inactivePaint =
        Paint()
          ..color = inactiveColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = arcStrokeWidth;

    final Paint activePaint =
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = arcStrokeWidth;

    // The arc starts at 225 degrees (5 * pi / 4) and sweeps 270 degrees (3 * pi / 2)
    const double startAngle = 8 * pi / 7; // 225 degrees
    const double sweepAngle = 2 * pi / 2.8; // 270 degrees

    // Draw inactive track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      inactivePaint,
    );

    // Calculate progress
    final double progress= currentValue/maxValue;
    final double activeSweepAngle = sweepAngle * progress;

    // Draw active progress
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      activeSweepAngle,
      false,
      activePaint,
    );

    // Draw thumb
    final double thumbAngle = startAngle + activeSweepAngle;
    final double thumbX = center.dx + radius * cos(thumbAngle);
    final double thumbY = center.dy + radius * sin(thumbAngle);

    // Thumb background circle (white with shadow)
    final Paint thumbBackgroundPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(thumbX, thumbY),
      thumbRadius,
      thumbBackgroundPaint,
    );

    // Add shadow to the thumb
    canvas.drawCircle(
      Offset(thumbX, thumbY),
      thumbRadius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );

    // Thumb foreground circle (green dot)
    final Paint thumbDotPaint =
        Paint()
          ..color = activeColor
          ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(thumbX, thumbY), thumbRadius * 0.3, thumbDotPaint);
  }

  @override
  bool shouldRepaint(covariant _ArcSliderPainter oldDelegate) {
    return oldDelegate.currentValue != currentValue ||
        oldDelegate.minValue != minValue ||
        oldDelegate.maxValue != maxValue ||
        oldDelegate.activeColor != activeColor ||
        oldDelegate.inactiveColor != inactiveColor ||
        oldDelegate.arcStrokeWidth != arcStrokeWidth ||
        oldDelegate.thumbRadius != thumbRadius;
  }
}
