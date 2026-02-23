import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/core/ui/theme/text_styles.dart';
import 'package:orderly/core/ui/widgets/app_snackbar.dart';
import 'package:orderly/core/ui/widgets/custom_button.dart';
import 'package:orderly/core/ui/widgets/custom_text_field.dart';
import 'package:orderly/core/utils/validators.dart';
import 'package:orderly/features/auth/domain/bloc/auth_bloc.dart';
import 'package:orderly/features/auth/presentation/widgets/welcome_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onForgotPasswordPressed() {
    // context.push(AppRoutes.forgotPassword);
  }

  void _onSignUpPressed() {
    // context.push(AppRoutes.adminRegister);
  }

  // ── BLoC listener ─────────────────────────────────────────────────────────

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    switch (state) {
      case AuthLoading():
        EasyLoading.show();

      case AuthAuthenticated():
        EasyLoading.dismiss();
        AppSnackbar.success(context, message: "Login Successfully");

      case AuthFailureState(:final message):
        EasyLoading.dismiss();
        AppSnackbar.error(context, message: message);

      case AuthUnauthenticated():
        EasyLoading.dismiss();

      default:
        break;
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _onAuthStateChanged,
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    WelcomeHeader(),
                    const SizedBox(height: 60),
                    _buildEmailField(),
                    const SizedBox(height: 20),
                    _buildPasswordField(),
                    const SizedBox(height: 16),
                    _buildRememberMeAndForgotPassword(),
                    const SizedBox(height: 40),
                    _buildLoginButton(),
                    const SizedBox(height: 30),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Private builders ───────────────────────────────────────────────────────

  Widget _buildEmailField() {
    return CustomTextField(
      controller: _emailController,
      label: 'Email Address',
      hintText: 'Enter your email',
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.email_outlined,
      validator: (value) => Validators.validateEmail(value),
    );
  }

  Widget _buildPasswordField() {
    return CustomTextField(
      controller: _passwordController,
      label: 'Password',
      hintText: 'Enter your password',
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onSubmitted: (_) {},
      prefixIcon: Icons.lock_outline,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (value) => Validators.validatePassword(value),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) =>
                  setState(() => _rememberMe = value ?? false),
              activeColor: AppColors.primary,
            ),
            Text(
              'Remember me',
              style: AppTextStyles.bodyText2.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: _onForgotPasswordPressed,
          child: Text(
            'Forgot Password?',
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // BlocBuilder only wraps the button — avoids rebuilding the entire screen
  // on every state change.
  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) =>
          current is AuthLoading || previous is AuthLoading,
      builder: (context, state) {
        return CustomButton(
          text: 'Sign In',
          onPressed: () {
            FocusScope.of(context).unfocus();

            if (!_formKey.currentState!.validate()) return;
            context.read<AuthBloc>().add(
              LoginRequested(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              ),
            );
          },
          backgroundColor: AppColors.primary,
          textColor: AppColors.white,
          elevation: 4,
          borderRadius: 12,
        );
      },
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodyText2.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        TextButton(
          onPressed: _onSignUpPressed,
          child: Text(
            'Sign Up',
            style: AppTextStyles.bodyText2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
