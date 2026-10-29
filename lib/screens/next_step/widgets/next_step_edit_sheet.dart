import 'package:flutter/material.dart';

import '../../../data/database/app_database.dart';
import '../../../repositories/action_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_button.dart';
import '../../../widgets/app_text_field.dart';

Future<void> showNextStepEditSheet(
  BuildContext context, {
  required ActionRepository repository,
  required DateTime date,
  DailyAction? action,
}) {
  return showAppBottomSheet(
    context: context,
    title: action == null ? '一歩を加える' : '一歩を書き直す',
    child: _NextStepEditForm(
      repository: repository,
      date: date,
      action: action,
    ),
  );
}

class _NextStepEditForm extends StatefulWidget {
  const _NextStepEditForm({
    required this.repository,
    required this.date,
    this.action,
  });

  final ActionRepository repository;
  final DateTime date;
  final DailyAction? action;

  @override
  State<_NextStepEditForm> createState() => _NextStepEditFormState();
}

class _NextStepEditFormState extends State<_NextStepEditForm> {
  late final _actionController = TextEditingController(
    text: widget.action?.action,
  );
  late final _reasonController = TextEditingController(
    text: widget.action?.reason,
  );
  String? _errorText;
  bool _saving = false;

  bool get _isEditing => widget.action != null;

  @override
  void dispose() {
    _actionController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final action = _actionController.text.trim();
    if (action.isEmpty) {
      setState(() => _errorText = 'してみることを、ひとこと書いてください');
      return;
    }

    setState(() => _saving = true);

    final reason = _reasonController.text;
    final saved = _isEditing
        ? await widget.repository.updateAction(
            widget.action!.id,
            action,
            reason,
          )
        : await widget.repository.addAction(
            widget.date,
            action,
            reason: reason,
          );
    if (!mounted) return;

    if (!saved) {
      setState(() {
        _saving = false;
        _errorText = '保存できませんでした。もう一度お試しください';
      });
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('この一歩を削除しますか？'),
        content: const Text('削除すると、元に戻せません。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('やめる'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.errorText),
            child: const Text('削除する'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await widget.repository.deleteAction(widget.action!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Question('今日、なにをしてみる？'),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _actionController,
          hintText: '例：10分だけ早く寝る',
          maxLines: 2,
          maxLength: ActionRepository.maxActionLength,
          errorText: _errorText,
          onChanged: (_) {
            if (_errorText != null) {
              setState(() => _errorText = null);
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        const _Question('それを選んだのは、なぜ？（任意）'),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _reasonController,
          hintText: '例：朝有意義な時間を作るため',
          minLines: 2,
          maxLines: 4,
          maxLength: ActionRepository.maxReasonLength,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: 'この一歩にする', onPressed: _save, isLoading: _saving),
        if (_isEditing) ...[
          const SizedBox(height: AppSpacing.sm),
          AppTextButton(
            label: 'この一歩を削除する',
            leadingIcon: AppIcons.delete,
            color: AppColors.errorText,
            onPressed: _saving ? null : _confirmDelete,
          ),
        ],
      ],
    );
  }
}

class _Question extends StatelessWidget {
  const _Question(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.emotionalMedium.copyWith(
        color: AppColors.textPrimary,
      ),
    );
  }
}
