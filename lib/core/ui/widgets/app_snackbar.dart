import 'package:flutter/material.dart';
import 'package:orderly/core/ui/theme/colors.dart';
import 'package:orderly/core/ui/theme/text_styles.dart';

enum _SnackbarType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  // ── Public API ─────────────────────────────────────────────────────────────

  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      type: _SnackbarType.success,
      message: message,
      title: title,
      duration: duration,
    );
  }

  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      context,
      type: _SnackbarType.error,
      message: message,
      title: title,
      duration: duration,
    );
  }

  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      type: _SnackbarType.warning,
      message: message,
      title: title,
      duration: duration,
    );
  }

  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      context,
      type: _SnackbarType.info,
      message: message,
      title: title,
      duration: duration,
    );
  }

  // ── Core builder ───────────────────────────────────────────────────────────

  static void _show(
    BuildContext context, {
    required _SnackbarType type,
    required String message,
    String? title,
    required Duration duration,
  }) {
    // Dismiss any existing snackbar before showing a new one.
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        content: _SnackbarContent(
          type: type,
          message: message,
          title: title,
        ),
      ),
    );
  }
}

// ── Internal widget ────────────────────────────────────────────────────────────

class _SnackbarContent extends StatelessWidget {
  const _SnackbarContent({
    required this.type,
    required this.message,
    this.title,
  });

  final _SnackbarType type;
  final String message;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final config = _SnackbarConfig.from(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(
            color: config.accentColor,
            width: 4,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildIcon(config),
          const SizedBox(width: 12),
          Expanded(child: _buildText(config)),
          _buildCloseButton(context, config),
        ],
      ),
    );
  }

  Widget _buildIcon(_SnackbarConfig config) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: config.accentColor.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: Icon(
        config.icon,
        color: config.accentColor,
        size: 18,
      ),
    );
  }

  Widget _buildText(_SnackbarConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: AppTextStyles.bodyText2.copyWith(
              color: config.accentColor,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
        ],
        Text(
          message,
          style: AppTextStyles.bodyText2.copyWith(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCloseButton(BuildContext context, _SnackbarConfig config) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
      child: Icon(
        Icons.close,
        size: 16,
        color: AppColors.textSecondary,
      ),
    );
  }
}

// ── Config ─────────────────────────────────────────────────────────────────────

class _SnackbarConfig {
  final Color backgroundColor;
  final Color accentColor;
  final IconData icon;

  const _SnackbarConfig({
    required this.backgroundColor,
    required this.accentColor,
    required this.icon,
  });

  factory _SnackbarConfig.from(_SnackbarType type) => switch (type) {
        _SnackbarType.success => _SnackbarConfig(
            backgroundColor: AppColors.successSurface,
            accentColor: AppColors.success,
            icon: Icons.check_circle_outline_rounded,
          ),
        _SnackbarType.error => _SnackbarConfig(
            backgroundColor: AppColors.errorSurface,
            accentColor: AppColors.error,
            icon: Icons.error_outline_rounded,
          ),
        _SnackbarType.warning => _SnackbarConfig(
            backgroundColor: AppColors.warningSurface,
            accentColor: AppColors.warning,
            icon: Icons.warning_amber_rounded,
          ),
        _SnackbarType.info => _SnackbarConfig(
            backgroundColor: AppColors.infoSurface,
            accentColor: AppColors.info,
            icon: Icons.info_outline_rounded,
          ),
      };
}