import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/core/ui/theme/text_styles.dart';
import 'package:orderly/core/ui/widgets/app_text.dart';

class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({super.key});



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppText(
          'Welcome Back',
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        AppText(
          'Sign in to continue to Orderly',
          style: AppTextStyles.bodyText1.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}