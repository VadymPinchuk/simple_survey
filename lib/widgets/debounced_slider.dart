import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedSlider extends StatefulWidget {
  const DebouncedSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  final double value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final Duration debounceDuration;

  @override
  State<StatefulWidget> createState() => _DebouncedSliderState();
}

class _DebouncedSliderState extends State<DebouncedSlider> {
  late double _currentValue;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: _currentValue,
      min: widget.min,
      max: widget.max,
      divisions: (widget.max - widget.min).toInt(),
      label: _currentValue.round().toString(),
      onChanged: (double value) {
        setState(() {
          _currentValue = value;
        });
        _onChanged(_currentValue);
      },
    );
  }

  _onChanged(double value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
