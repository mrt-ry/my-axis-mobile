import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

enum AppButtonVariant { primary, secondary }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final onTap = isLoading ? null : onPressed;
    final child = isLoading ? _buildSpinner() : _buildLabel();

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(
          onPressed: onTap,
          style: _primaryStyle(),
          child: child,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: onTap,
          style: _secondaryStyle(),
          child: child,
        );
    }
  }

  Widget _buildLabel() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(child: Text(label, textAlign: TextAlign.center)),
        if (trailingIcon != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Icon(trailingIcon, size: 20),
        ],
      ],
    );
  }

  Widget _buildSpinner() {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.primary,
      ),
    );
  }

  ButtonStyle _primaryStyle() {
    return ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size.fromHeight(52)),
      shape: WidgetStatePropertyAll(_shape),
      textStyle: const WidgetStatePropertyAll(AppTypography.labelMedium),
      foregroundColor: const WidgetStatePropertyAll(AppColors.onPrimary),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isLoading ? AppColors.primaryTint : AppColors.disabled;
        }
        if (states.contains(WidgetState.pressed)) {
          return AppColors.primaryPressed;
        }
        return AppColors.primary;
      }),
    );
  }

  ButtonStyle _secondaryStyle() {
    return ButtonStyle(
      minimumSize: WidgetStatePropertyAll(Size.fromHeight(48)),
      shape: WidgetStatePropertyAll(_shape),
      textStyle: const WidgetStatePropertyAll(AppTypography.labelMedium),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) return AppColors.primaryTint;
        return AppColors.surface;
      }),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return isLoading ? AppColors.primary : AppColors.disabled;
        }
        return AppColors.primary;
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final color = states.contains(WidgetState.disabled) && !isLoading
            ? AppColors.disabled
            : AppColors.primary;
        return BorderSide(color: color);
      }),
    );
  }

  static final _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.button),
  );
}
