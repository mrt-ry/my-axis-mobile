import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.hintText,
    this.errorText,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.onChanged,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? errorText;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      minLines: minLines,
      onChanged: onChanged,
      style: AppTypography.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyLarge.copyWith(color: AppColors.textHint),
        errorText: errorText,
        filled: true,
        fillColor: enabled ? AppColors.surface : AppColors.background,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        enabledBorder: _border(AppColors.border),
        disabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary, width: 1.5),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error, width: 1.5),
      ),
    );
  }

  static OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.button),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
