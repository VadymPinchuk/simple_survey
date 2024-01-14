import 'package:flutter/material.dart';
import 'package:simple_survey/main.dart';

class BarChart extends StatefulWidget {
  const BarChart({
    super.key,
    required this.count,
    required this.data,
  });

  final int count;
  final Map<String, dynamic> data;

  @override
  State<StatefulWidget> createState() => _BarChartState();
}

class _BarChartState extends State<BarChart> with SingleTickerProviderStateMixin {
  late List<Animation<double>> _barAnimations;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _barAnimations = widget.data.entries.map((entry) {
      return Tween<double>(
        begin: 0,
        end: entry.value.toDouble(),
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    _controller.forward();
  }

  @override
  void didUpdateWidget(BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _barAnimations = widget.data.entries.map((entry) {
        return Tween<double>(
                begin: _barAnimations[oldWidget.data.keys.toList().indexOf(entry.key)].value,
                end: entry.value.toDouble())
            .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );
      }).toList();

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (size.width > size.height) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBarChart(context),
              const SizedBox(width: 16),
              _buildLegend(),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBarChart(context),
              const SizedBox(height: 16),
              _buildLegend(),
            ],
          );
        }
      },
    );
  }

  Widget _buildBarChart(BuildContext context) {
    return CustomPaint(
      painter: BarChartPainter(
        _barAnimations,
        widget.data,
        Theme.of(context).colorScheme.onBackground,
        widget.count,
      ),
      child: SizedBox(width: widget.data.length * 50, height: 150),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.data.entries.indexed.map((item) {
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
    this.barAnimations,
    this.data,
    this.textColor,
    this.count,
  );

  final List<Animation<double>> barAnimations;
  final Map<String, dynamic> data;
  final Color textColor;
  final int count;

  @override
  void paint(Canvas canvas, Size size) {
    double barWidth = 30;
    var paint = Paint()..style = PaintingStyle.fill;
    int i = 0;

    data.forEach((key, value) {
      final barHeight = barAnimations[i].value * size.height / count; // Assuming max value is 100
      paint.color = rainbowColors[i % rainbowColors.length];

      // Draw bar
      canvas.drawRect(
        Rect.fromLTWH(i * barWidth * 2, size.height - barHeight, barWidth, barHeight),
        paint,
      );

      // Calculate percentage
      double percentage = (value / count) * 100;
      String percentageText = '${percentage.toStringAsFixed(0)} %';

      // Draw percentage text
      final span = TextSpan(
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
        text: percentageText,
      );
      final textPainter = TextPainter(
        text: span,
        textDirection: TextDirection.ltr,
        maxLines: 1,
      );
      textPainter.layout(
        minWidth: barWidth,
        maxWidth: barWidth,
      );
      final xCenter = (i * barWidth * 2) + (barWidth / 2) - (textPainter.width / 2);
      final yPosition = size.height - barHeight - 15; // Adjust as needed
      textPainter.paint(canvas, Offset(xCenter, yPosition));

      i++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
