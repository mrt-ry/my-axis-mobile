import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../providers/repository_providers.dart';
import '../../../repositories/vision_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';

Future<void> showIdealEditSheet(BuildContext context, {Ideal? ideal}) {
  return showAppBottomSheet(
    context: context,
    title: ideal == null ? '理想の状態を追加' : '理想の状態を編集',
    child: _IdealEditForm(ideal: ideal),
  );
}

class _IdealEditForm extends ConsumerStatefulWidget {
  const _IdealEditForm({this.ideal});

  final Ideal? ideal;

  @override
  ConsumerState<_IdealEditForm> createState() => _IdealEditFormState();
}

class _IdealEditFormState extends ConsumerState<_IdealEditForm> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.ideal?.content,
  );
  String? _errorText;
  bool _saving = false;

  bool get _isEditing => widget.ideal != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() {
        _errorText = '内容を入力してください';
      });
      return;
    }

    setState(() => _saving = true);

    final repository = ref.read(visionRepositoryProvider);
    final saved = _isEditing
        ? await repository.updateIdeal(widget.ideal!.id, text)
        : await repository.addIdeal(text);
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
        title: const Text('この理想を削除しますか？'),
        content: const Text('削除すると元に戻せません。'),
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

    await ref.read(visionRepositoryProvider).deleteIdeal(widget.ideal!.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'どんな自分で、どんな毎日を過ごしたいですか？',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _controller,
          hintText: '例：家族と穏やかに過ごしている自分',
          minLines: 4,
          maxLines: 6,
          maxLength: VisionRepository.maxIdealLength,
          errorText: _errorText,
          onChanged: (_) {
            if (_errorText != null) {
              setState(() => _errorText = null);
            }
          },
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(label: '保存する', onPressed: _save, isLoading: _saving),
        if (_isEditing) ...[
          const SizedBox(height: AppSpacing.sm),
          TextButton.icon(
            onPressed: _confirmDelete,
            icon: const Icon(AppIcons.delete, size: 20),
            label: const Text('この理想を削除'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.errorText,
              minimumSize: const Size.fromHeight(48),
            ),
          ),
        ],
      ],
    );
  }
}
