import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly/core/router/app_routes.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/core/ui/widgets/app_snackbar.dart';
import 'package:orderly/core/utils/validators.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/auth/presentation/widgets/dark_text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // Entrance animations
  late final AnimationController _fadeCtrl;
  late final AnimationController _slideCtrl;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(const AuthCheckRequested());

    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _slideCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _fadeCtrl.forward();
    Future.delayed(const Duration(milliseconds: 100),
        () { if (mounted) _slideCtrl.forward(); });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeCtrl.dispose();
    _slideCtrl.dispose();
    super.dispose();
  }

  void _onForgotPasswordPressed() {
    // context.push(AppRoutes.forgotPassword);
  }

  void _onSignUpPressed() {
    // context.push(AppRoutes.adminRegister);
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoading():
        EasyLoading.dismiss();
        EasyLoading.show(status: 'Logging in...');
        break;
      case AuthAuthenticated():
        EasyLoading.dismiss();
        context.go(AppRoutes.home);
        AppSnackbar.success(context, message: "Login Successfully");
        EasyLoading.dismiss();
      case AuthFailureState(:final message):
        EasyLoading.dismiss();
        AppSnackbar.error(context, message: message);
      case AuthUnauthenticated():
        EasyLoading.dismiss();
      default:
        break;
    }
  }

  Animation<double> _itemFade(double start, double end) => CurvedAnimation(
        parent: _slideCtrl,
        curve: Interval(start, end, curve: Curves.easeOut),
      );

  Animation<Offset> _itemSlide(double start, double end) =>
      Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero).animate(
        CurvedAnimation(
          parent: _slideCtrl,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _onAuthStateChanged,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          child: FadeTransition(
            opacity: _fadeCtrl,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      
                      FadeTransition(
                        opacity: _itemFade(0.0, 0.4),
                        child: SlideTransition(
                          position: _itemSlide(0.0, 0.4),
                          child: _buildBrand(),
                        ),
                      ),
                      const SizedBox(height: 48),

                      
                      FadeTransition(
                        opacity: _itemFade(0.15, 0.55),
                        child: SlideTransition(
                          position: _itemSlide(0.15, 0.55),
                          child: _buildEmailField(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      
                      FadeTransition(
                        opacity: _itemFade(0.25, 0.65),
                        child: SlideTransition(
                          position: _itemSlide(0.25, 0.65),
                          child: _buildPasswordField(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      
                      FadeTransition(
                        opacity: _itemFade(0.35, 0.75),
                        child: SlideTransition(
                          position: _itemSlide(0.35, 0.75),
                          child: _buildRememberMeAndForgotPassword(),
                        ),
                      ),
                      const SizedBox(height: 32),

                      
                      FadeTransition(
                        opacity: _itemFade(0.5, 0.9),
                        child: SlideTransition(
                          position: _itemSlide(0.5, 0.9),
                          child: _buildLoginButton(),
                        ),
                      ),
                      const SizedBox(height: 28),

                      
                      FadeTransition(
                        opacity: _itemFade(0.65, 1.0),
                        child: _buildSignUpLink(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildBrand() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo mark
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF0A500), Color(0xFFE08800)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.amber.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.storefront_rounded,
              color: Colors.black, size: 26),
        ),
        const SizedBox(height: 28),
        const Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: AppColors.text,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to your account to continue.',
          style: TextStyle(fontSize: 14, color: AppColors.muted, height: 1.4),
        ),
      ],
    );
  }

  // ── Fields ──────────────────────────────────────────────────────────────────
  Widget _buildEmailField() {
    return DarkTextField(
      controller: _emailController,
      label: 'Email Address',
      hint: 'you@example.com',
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (v) => Validators.validateEmail(v),
    );
  }

  Widget _buildPasswordField() {
    return DarkTextField(
      controller: _passwordController,
      label: 'Password',
      hint: '••••••••',
      icon: Icons.lock_outline_rounded,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      validator: (v) => Validators.validatePassword(v),
      suffixIcon: GestureDetector(
        onTap: () => setState(() => _obscurePassword = !_obscurePassword),
        child: Icon(
          _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          color: AppColors.muted,
          size: 19,
        ),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: _rememberMe ? AppColors.amber : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _rememberMe ? AppColors.amber : AppColors.muted,
                    width: 1.5,
                  ),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check_rounded, size: 13, color: Colors.black)
                    : null,
              ),
              const SizedBox(width: 8),
              const Text('Remember me',
                  style: TextStyle(fontSize: 13, color: AppColors.muted)),
            ],
          ),
        ),

        // Forgot password
        GestureDetector(
          onTap: _onForgotPasswordPressed,
          child: const Text(
            'Forgot password?',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.amber,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthLoading || previous is AuthLoading,
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  if (!_formKey.currentState!.validate()) return;
                  context.read<AuthBloc>().add(
                    LoginRequested(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    ),
                  );
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 54,
            decoration: BoxDecoration(
              color: isLoading ? AppColors.amber.withOpacity(0.5) : AppColors.amber,
              borderRadius: BorderRadius.circular(14),
              boxShadow: isLoading
                  ? []
                  : [
                      BoxShadow(
                        color: AppColors.amber.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
                      ),
                    )
                  : const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.3,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(fontSize: 13, color: AppColors.muted),
        ),
        GestureDetector(
          onTap: _onSignUpPressed,
          child: const Text(
            'Sign Up',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.amber,
            ),
          ),
        ),
      ],
    );
  }
}
