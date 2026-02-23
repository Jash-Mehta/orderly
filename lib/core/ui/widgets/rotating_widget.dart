// coverage:ignore-file

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget that rotates its child continuously.
class RotatingWidget extends StatefulWidget {
  final Widget child;

  const RotatingWidget({
    super.key,
    required this.child,
  });

  @override
  State<RotatingWidget> createState() => _RotatingWidgetState();
}

class _RotatingWidgetState extends State<RotatingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 8,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, innerChild) {
          return Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: innerChild,
          );
        },
        child: widget.child,
      ),
    );
  }
}
