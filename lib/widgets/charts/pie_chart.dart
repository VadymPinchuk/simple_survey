import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_survey/main.dart';

class PieChart extends StatefulWidget {
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
  State<StatefulWidget> createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> with SingleTickerProviderStateMixin {
  late List<Animation<double>> _segmentAnimations;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _initAnimations();
    _controller.forward();
  }

  void _initAnimations() {
    double total = widget.data.fold(0, (sum, item) => sum + item);
    double start = 0;

    _segmentAnimations = widget.data.map((value) {
      double end = value / total;
      var tween = Tween<double>(begin: start, end: start + end);
      start += end;
      return tween.animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }).toList();
  }

  @override
  void didUpdateWidget(PieChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      _initAnimations();
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
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomPaint(
              painter: PieChartPainter(_segmentAnimations),
              child: SizedBox(
                width: widget.chartRadius * 2,
                height: widget.chartRadius * 2,
              ),
            ),
            const SizedBox(width: 16),
            _buildLabels(context),
          ],
        );
      },
    );
  }

  Widget _buildLabels(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widget.labels.indexed.map((entry) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.circle, color: rainbowColors[entry.$1 % rainbowColors.length], size: 12),
            const SizedBox(width: 4),
            Text('${entry.$2} : ${widget.data[entry.$1].toStringAsFixed(0)}'),
          ],
        );
      }).toList(),
    );
  }
}

class PieChartPainter extends CustomPainter {
  PieChartPainter(this.segmentAnimations);

  final List<Animation<double>> segmentAnimations;

  @override
  void paint(Canvas canvas, Size size) {
    double startAngle = -pi / 2;

    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < segmentAnimations.length; i++) {
      final animation = segmentAnimations[i];
      final sweepAngle = (animation.value - (i > 0 ? segmentAnimations[i - 1].value : 0)) * 2 * pi;
      paint.color = rainbowColors[i % rainbowColors.length];

      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: size.width,
          height: size.height,
        ),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) => true;
}
