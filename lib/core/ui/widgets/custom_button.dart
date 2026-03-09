import 'package:flutter/material.dart';

enum ButtonType {
  primary,
  secondary,
  outline,
  ghost,
}

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  final double? borderRadius;
  final double? height;
  final double? width;
  final Widget? child;
  final bool isLoading;
  final bool disabled;
  final ButtonType type;
  final bool enableAnimation;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.elevation,
    this.borderRadius,
    this.height,
    this.width,
    this.child,
    this.isLoading = false,
    this.disabled = false,
    this.type = ButtonType.primary,
    this.enableAnimation = true,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    if (widget.enableAnimation) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        reverseDuration: const Duration(milliseconds: 180),
      );
      _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeIn),
      );
    }
  }

  @override
  void dispose() {
    if (widget.enableAnimation) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;
    
    if (widget.enableAnimation) {
      await _controller.forward();
      await _controller.reverse();
    }
    
    widget.onPressed!();
  }

  Color _getBackgroundColor() {
    if (widget.disabled || widget.isLoading) {
      switch (widget.type) {
        case ButtonType.primary:
          return (widget.backgroundColor ?? Theme.of(context).primaryColor).withOpacity(0.5);
        case ButtonType.secondary:
          return Colors.grey.withOpacity(0.3);
        case ButtonType.outline:
        case ButtonType.ghost:
          return Colors.transparent;
      }
    }
    
    switch (widget.type) {
      case ButtonType.primary:
        return widget.backgroundColor ?? Theme.of(context).primaryColor;
      case ButtonType.secondary:
        return widget.backgroundColor ?? Colors.grey[300]!;
      case ButtonType.outline:
      case ButtonType.ghost:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (widget.disabled || widget.isLoading) {
      switch (widget.type) {
        case ButtonType.primary:
        case ButtonType.secondary:
          return Colors.white54;
        case ButtonType.outline:
        case ButtonType.ghost:
          return Colors.grey.withOpacity(0.5);
      }
    }
    
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return widget.textColor ?? Colors.white;
      case ButtonType.outline:
      case ButtonType.ghost:
        return widget.textColor ?? Theme.of(context).primaryColor;
    }
  }

  BorderSide _getBorderSide() {
    switch (widget.type) {
      case ButtonType.outline:
        return BorderSide(
          color: widget.disabled || widget.isLoading
              ? Colors.grey.withOpacity(0.3)
              : (widget.backgroundColor ?? Theme.of(context).primaryColor),
          width: 1,
        );
      case ButtonType.ghost:
      case ButtonType.primary:
      case ButtonType.secondary:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonContent = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.prefixIcon != null) ...[
              widget.prefixIcon!,
              const SizedBox(width: 8),
            ],
            Text(
              widget.text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getTextColor(),
              ),
            ),
            if (widget.suffixIcon != null) ...[
              const SizedBox(width: 8),
              widget.suffixIcon!,
            ],
          ],
        );

    final buttonWidget = SizedBox(
      width: widget.width ?? double.infinity,
      height: widget.height ?? 48,
      child: ElevatedButton(
        onPressed: (widget.disabled || widget.isLoading) ? null : _handlePress,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(),
          foregroundColor: _getTextColor(),
          elevation: widget.elevation ?? (widget.type == ButtonType.outline || widget.type == ButtonType.ghost ? 0 : 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
            side: _getBorderSide(),
          ),
        ),
        child: widget.isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getTextColor()),
                ),
              )
            : buttonContent,
      ),
    );

    if (widget.enableAnimation) {
      return ScaleTransition(
        scale: _scale,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}
