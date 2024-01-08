import 'package:flutter/material.dart';
import 'package:simple_survey/main.dart';

class BarChart extends StatelessWidget {
  const BarChart({
    super.key,
    required this.count,
    required this.data,
  });

  final int count;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBarChart(context),
        const SizedBox(width: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return CustomPaint(
      painter: BarChartPainter(count, data, Theme.of(context).colorScheme.onBackground),
      child: SizedBox(width: data.length * 50, height: 200),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.indexed.map((item) {
        String label = item.$2.key;
        return Row(
          children: [
            Icon(Icons.circle, color: rainbowColors[item.$1]),
            const SizedBox(width: 8),
            Text(label),
          ],
        );
      }).toList(),
    );
  }
}

class BarChartPainter extends CustomPainter {
  BarChartPainter(
    this.count,
    this.data,
    this.textColor,
  );

  final int count;
  final Map<String, dynamic> data;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    double barWidth = 25;
    var paint = Paint()..style = PaintingStyle.fill;
    int i = 0;

    data.forEach((key, value) {
      final barHeight = value * size.height / count; // Assuming max value is 100
      paint.color = rainbowColors[i % rainbowColors.length];

      // Draw bar
      canvas.drawRect(
        Rect.fromLTWH(i * barWidth * 2, size.height - barHeight, barWidth, barHeight),
        paint,
      );

      // Draw text
      final span = TextSpan(
        style: TextStyle(color: textColor),
        text: value.toString(),
      );
      final textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(
        minWidth: 0,
        maxWidth: size.width,
      );
      final xCenter = (i * barWidth * 2) + (barWidth / 2) - (textPainter.width / 2);
      final yPosition = size.height - barHeight - 20; // Adjust as needed
      textPainter.paint(canvas, Offset(xCenter, yPosition));
      i++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
