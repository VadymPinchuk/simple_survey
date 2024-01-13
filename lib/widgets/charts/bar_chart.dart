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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBarChart(context),
            const SizedBox(width: 16),
            _buildLegend(),
          ],
        );
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
      child: SizedBox(width: widget.data.length * 50, height: 200),
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
    double barWidth = 25;
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

      // Draw text (remains the same as before)
      i++;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
