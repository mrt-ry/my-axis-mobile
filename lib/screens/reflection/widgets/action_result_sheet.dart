import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../providers/repository_providers.dart';
import '../../../repositories/action_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';

Future<void> showActionResultSheet(
  BuildContext context, {
  required DailyAction action,
}) {
  return showAppBottomSheet(
    context: context,
    title: '一歩をふりかえる',
    child: _ActionResultForm(action: action),
  );
}

class _ActionResultForm extends ConsumerStatefulWidget {
  const _ActionResultForm({required this.action});

  final DailyAction action;

  @override
  ConsumerState<_ActionResultForm> createState() => _ActionResultFormState();
}

class _ActionResultFormState extends ConsumerState<_ActionResultForm> {
  // まだ答えていないときは、どちらも選ばれていない状態から始める
  late ActionStatus? _status = widget.action.status == ActionStatus.unanswered
      ? null
      : widget.action.status;
  late final _noteController = TextEditingController(
    text: widget.action.resultNote,
  );
  String? _errorText;
  bool _saving = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);

    final saved = await ref
        .read(actionRepositoryProvider)
        .updateStatus(
          widget.action.id,
          _status!,
          resultNote: _noteController.text,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.action.action,
          style: AppTypography.bodyLarge.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: AppSpacing.lg),
        const _Question('この一歩は、どうだった？'),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _StatusOption(
                status: ActionStatus.done,
                selected: _status == ActionStatus.done,
                onTap: () => setState(() => _status = ActionStatus.done),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatusOption(
                status: ActionStatus.notDone,
                selected: _status == ActionStatus.notDone,
                onTap: () => setState(() => _status = ActionStatus.notDone),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _Question('ひとこと残すなら？（任意）'),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _noteController,
          hintText: '例：思ったより気持ちよかった',
          minLines: 2,
          maxLines: 3,
          maxLength: ActionRepository.maxResultNoteLength,
          errorText: _errorText,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: '保存する',
          // どちらかを選ぶまでは押せない
          onPressed: _status == null ? null : _save,
          isLoading: _saving,
        ),
      ],
    );
  }
}

class _StatusOption extends StatelessWidget {
  const _StatusOption({
    required this.status,
    required this.selected,
    required this.onTap,
  });

  final ActionStatus status;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (status) {
      ActionStatus.done => (AppIcons.statusDone, 'できた'),
      _ => (AppIcons.statusNotDone, 'できなかった'),
    };
    final radius = BorderRadius.circular(AppRadius.button);

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: selected ? AppColors.primaryTint : AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: Container(
            constraints: const BoxConstraints(minHeight: 52),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.border,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 22,
                  fill: selected ? 1 : 0,
                  color: selected ? AppColors.primary : AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  label,
                  style: AppTypography.labelMedium.copyWith(
                    color: selected
                        ? AppColors.onPrimaryTint
                        : AppColors.textPrimary,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
