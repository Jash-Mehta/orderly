import 'package:flutter/material.dart';

enum CardType {
  elevated,
  outlined,
  filled,
}

class BaseCard extends StatefulWidget {
  final Widget child;
  final CardType type;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final bool enableAnimation;
  final BoxShadow? boxShadow;

  const BaseCard({
    Key? key,
    required this.child,
    this.type = CardType.elevated,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.enableAnimation = true,
    this.boxShadow,
  }) : super(key: key);

  @override
  State<BaseCard> createState() => _BaseCardState();
}

class _BaseCardState extends State<BaseCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation && widget.onTap != null) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        reverseDuration: const Duration(milliseconds: 120),
      );
      _scale = Tween<double>(begin: 1.0, end: 0.98).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation && widget.onTap != null) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onTap == null) return;
    
    if (widget.enableAnimation) {
      await _controller.forward();
      await _controller.reverse();
    }
    
    widget.onTap!();
  }

  BoxDecoration _getDecoration() {
    switch (widget.type) {
      case CardType.elevated:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          boxShadow: widget.boxShadow != null 
              ? [widget.boxShadow!]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: widget.elevation ?? 8,
                    offset: Offset(0, widget.elevation ?? 4),
                  ),
                ],
        );
      case CardType.outlined:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          border: Border.all(
            color: widget.borderColor ?? Colors.grey.shade300,
            width: 1,
          ),
        );
      case CardType.filled:
        return BoxDecoration(
          color: widget.backgroundColor ?? Colors.grey.shade100,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidget = Container(
      width: widget.width,
      height: widget.height,
      margin: widget.margin,
      decoration: _getDecoration(),
      child: Padding(
        padding: widget.padding ?? const EdgeInsets.all(16),
        child: widget.child,
      ),
    );

    if (widget.onTap != null && widget.enableAnimation) {
      return ScaleTransition(
        scale: _scale,
        child: GestureDetector(
          onTap: _handleTap,
          child: cardWidget,
        ),
      );
    }

    if (widget.onTap != null) {
      return GestureDetector(
        onTap: widget.onTap,
        child: cardWidget,
      );
    }

    return cardWidget;
  }
}
