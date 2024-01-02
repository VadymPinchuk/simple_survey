import 'dart:async';

import 'package:flutter/material.dart';

class DebouncedTextField extends StatefulWidget {
  const DebouncedTextField({
    super.key,
    required this.text,
    this.debounceDuration = const Duration(milliseconds: 300),
    this.decoration,
    this.labelText,
    this.style,
    this.maxLines = 1,
    this.padding,
    required this.onChanged,
  });

  final String text;
  final Function(String) onChanged;
  final Duration debounceDuration;

  final InputDecoration? decoration;
  final String? labelText;
  final TextStyle? style;
  final int maxLines;
  final EdgeInsets? padding;

  @override
  State<StatefulWidget> createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  late TextEditingController _controller;
  Timer? _debounce;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _controller.text = widget.text;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(4.0),
      child: TextField(
        style: widget.style,
        controller: _controller,
        maxLines: widget.maxLines,
        textCapitalization: TextCapitalization.sentences,
        onChanged: _onChanged,
        decoration: widget.decoration ??
            InputDecoration(
              labelText: widget.labelText ?? '',
              border: const OutlineInputBorder(),
            ),
      ),
    );
  }

  void _onChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(widget.debounceDuration, () {
      widget.onChanged(text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
