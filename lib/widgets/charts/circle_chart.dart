import 'package:flutter/material.dart';

class CircleChart extends StatefulWidget {
  const CircleChart({
    super.key,
    required this.maxScore,
    required this.averageScore,
    this.size = 100.0,
    this.strokeWidth = 15.0,
  });

  final double maxScore;
  final double averageScore;
  final double size;
  final double strokeWidth;

  @override
  State<StatefulWidget> createState() => _CircleChartState();
}

class _CircleChartState extends State<CircleChart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.averageScore).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    )..addListener(() {
        setState(() {});
      });

    _controller.forward();
  }

  @override
  void didUpdateWidget(CircleChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.averageScore != widget.averageScore) {
      _animation = Tween<double>(begin: oldWidget.averageScore, end: widget.averageScore).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut),
      );

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
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            value: _animation.value / widget.maxScore,
            strokeWidth: widget.strokeWidth,
            backgroundColor: Colors.grey.shade300,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text(
          '${_animation.value.toStringAsFixed(1)} / ${widget.maxScore.toStringAsFixed(0)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
