import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../models/reflection_entry_with_emotions.dart';
import '../../../providers/reflection_providers.dart';
import '../../../providers/repository_providers.dart';
import '../../../repositories/reflection_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/selectable_value_chip.dart';

Future<void> showReflectionEntrySheet(
  BuildContext context, {
  required DateTime date,
  required ReflectionKind kind,
  ReflectionEntryWithEmotions? item,
}) {
  return showAppBottomSheet(
    context: context,
    title: switch (kind) {
      ReflectionKind.good => '自分らしかったこと',
      ReflectionKind.discomfort => '違和感',
    },
    child: _ReflectionEntryForm(date: date, kind: kind, item: item),
  );
}

class _ReflectionEntryForm extends ConsumerStatefulWidget {
  const _ReflectionEntryForm({
    required this.date,
    required this.kind,
    this.item,
  });

  final DateTime date;
  final ReflectionKind kind;
  final ReflectionEntryWithEmotions? item;

  @override
  ConsumerState<_ReflectionEntryForm> createState() =>
      _ReflectionEntryFormState();
}

class _ReflectionEntryFormState extends ConsumerState<_ReflectionEntryForm> {
  late final _controller = TextEditingController(
    text: widget.item?.entry.content,
  );
  // 選んでいる気持ちのID（保存するまでDBは変わらない）
  late final Set<String> _emotionIds = {
    ...?widget.item?.emotions.map((e) => e.id),
  };
  String? _errorText;
  String? _emotionMessage;
  bool _saving = false;

  bool get _isEditing => widget.item != null;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleEmotion(String id) {
    setState(() {
      if (_emotionIds.contains(id)) {
        _emotionIds.remove(id);
        _emotionMessage = null;
      } else if (_emotionIds.length >=
          ReflectionRepository.maxEmotionsPerEntry) {
        _emotionMessage =
            '気持ちは${ReflectionRepository.maxEmotionsPerEntry}つまでです。'
            '入れ替えるときは、選択を外してください。';
      } else {
        _emotionIds.add(id);
        _emotionMessage = null;
      }
    });
  }

  Future<void> _save() async {
    final content = _controller.text.trim();
    if (content.isEmpty) {
      setState(() => _errorText = 'どんなことがあったか、ひとこと書いてください');
      return;
    }

    setState(() => _saving = true);

    final repository = ref.read(reflectionRepositoryProvider);
    final emotionIds = _emotionIds.toList();
    final saved = _isEditing
        ? await repository.updateEntry(
            widget.item!.entry.id,
            content,
            emotionIds,
          )
        : await repository.addEntry(
            widget.date,
            widget.kind,
            content,
            emotionIds,
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
        title: const Text('このできごとを削除しますか？'),
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

    await ref
        .read(reflectionRepositoryProvider)
        .deleteEntry(widget.item!.entry.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Question('どんなことがあった？'),
        const SizedBox(height: AppSpacing.sm),
        AppTextField(
          controller: _controller,
          hintText: switch (widget.kind) {
            ReflectionKind.good => '例：会議で、自分の意見を言えた',
            ReflectionKind.discomfort => '例：断りたい誘いを、断れなかった',
          },
          minLines: 2,
          maxLines: 4,
          maxLength: ReflectionRepository.maxEntryLength,
          errorText: _errorText,
          onChanged: (_) {
            if (_errorText != null) {
              setState(() => _errorText = null);
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            const Expanded(child: _Question('そのとき、どんな気持ち？（任意）')),
            Text(
              '${_emotionIds.length} / ${ReflectionRepository.maxEmotionsPerEntry}',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _buildEmotions(),
        if (_emotionMessage != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            _emotionMessage!,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: '保存する', onPressed: _save, isLoading: _saving),
        if (_isEditing) ...[
          const SizedBox(height: AppSpacing.sm),
          AppTextButton(
            label: 'このできごとを削除する',
            leadingIcon: AppIcons.delete,
            color: AppColors.errorText,
            onPressed: _saving ? null : _confirmDelete,
          ),
        ],
      ],
    );
  }

  // 気持ちのタグ（3列）
  Widget _buildEmotions() {
    final emotions = switch (ref.watch(emotionsProvider(widget.kind))) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (emotions == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 3;
        const gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final emotion in emotions)
              SizedBox(
                width: width,
                child: SelectableValueChip(
                  label: emotion.label,
                  selected: _emotionIds.contains(emotion.id),
                  onTap: () => _toggleEmotion(emotion.id),
                ),
              ),
          ],
        );
      },
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
