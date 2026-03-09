import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/home/domain/bloc/home_bloc.dart';

class SubmitButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const SubmitButton({super.key, required this.isLoading, required this.onPressed});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _btnController;
  late final Animation<double> _btnScale;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _btnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _btnScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _btnController, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _btnController.dispose();
    super.dispose();
  }

  Future<void> _handlePress() async {
    if (widget.onPressed == null) return;
    setState(() => _pressed = true);
    await _btnController.forward();
    await _btnController.reverse();
    setState(() => _pressed = false);
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _btnScale,
      child: GestureDetector(
        onTap: _handlePress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.chineseBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.chineseBlue.withOpacity(0.3),
                blurRadius: _pressed ? 8 : 16,
                offset: Offset(0, _pressed ? 3 : 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: widget.isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Proceed to Checkout',
                        key: ValueKey('label'),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
