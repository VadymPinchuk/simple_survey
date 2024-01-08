import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_survey/main.dart';
import 'package:simple_survey/widgets/bar_chart.dart';

class PieChart extends StatelessWidget {
  const PieChart({
    super.key,
    required this.data,
    required this.labels,
    this.chartRadius = 50.0,
  });

  final List<double> data;
  final List<String> labels;
  final double chartRadius;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          painter: PieChartPainter(data),
          child: SizedBox(
            width: chartRadius * 2,
            height: chartRadius * 2,
          ),
        ),
        const SizedBox(width: 16),
        _buildLabels(context),
      ],
    );
  }

  Widget _buildLabels(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: labels.indexed.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.circle, color: rainbowColors[entry.$1 % rainbowColors.length], size: 12),
            const SizedBox(width: 4),
            Text('${entry.$2} : ${data[entry.$1].toStringAsFixed(0)}'),
          ],
        );
      }).toList(),
    );
  }
}

class PieChartPainter extends CustomPainter {
  PieChartPainter(this.data);

  final List<double> data;

  @override
  void paint(Canvas canvas, Size size) {
    double total = data.fold(0, (sum, item) => sum + item);
    double startAngle = -pi / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = data[i] / total * 2 * pi;
      paint.color = rainbowColors[i % rainbowColors.length];
      canvas.drawArc(
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: size.height),
        startAngle,
        sweepAngle,
        true,
        paint,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
