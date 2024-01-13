import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedRangeSlider extends StatefulWidget {
  const DebouncedRangeSlider({
    super.key,
    required this.values,
    required this.min,
    required this.max,
    required this.onChanged,
    this.debounceDuration = const Duration(milliseconds: 300),
  });

  final RangeValues values;
  final double min;
  final double max;
  final Function(RangeValues) onChanged;
  final Duration debounceDuration;

  @override
  State<StatefulWidget> createState() => _DebouncedRangeSliderState();
}

class _DebouncedRangeSliderState extends State<DebouncedRangeSlider> {
  late RangeValues _currentRangeValues;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _currentRangeValues = widget.values;
  }

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: _currentRangeValues,
      min: widget.min,
      max: widget.max,
      divisions: (widget.max - widget.min).toInt(),
      labels: RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString(),
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _currentRangeValues = values;
        });
        _onRangeChanged(values);
      },
    );
  }

  _onRangeChanged(RangeValues values) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(values);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
