import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/repository_providers.dart';
import '../../../repositories/reflection_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_text_field.dart';

class ReflectionNoteField extends ConsumerStatefulWidget {
  const ReflectionNoteField({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<ReflectionNoteField> createState() =>
      _ReflectionNoteFieldState();
}

class _ReflectionNoteFieldState extends ConsumerState<ReflectionNoteField> {
  // 書くのが止まってから、保存するまでの待ち時間
  static const _saveDelay = Duration(milliseconds: 800);

  final _controller = TextEditingController();
  // dispose中ではrefを使えないため、先に取り出しておく
  late final ReflectionRepository _repository;
  Timer? _saveTimer;
  bool _loaded = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _repository = ref.read(reflectionRepositoryProvider);
    _load();
  }

  // 開いたときに1回だけ読む（見張ると書いている途中の文字が上書きされるため）
  Future<void> _load() async {
    final note = await _repository.watchNoteByDate(widget.date).first;
    if (!mounted) return;
    setState(() {
      _controller.text = note?.content ?? '';
      _loaded = true;
    });
  }

  void _onChanged(String _) {
    _saveTimer?.cancel();
    _saveTimer = Timer(_saveDelay, _save);
    if (_saved) setState(() => _saved = false);
  }

  Future<void> _save() async {
    final saved = await _repository.saveNote(widget.date, _controller.text);
    if (!mounted) return;
    setState(() => _saved = saved);
  }

  @override
  void dispose() {
    // 保存を待っている途中で画面を閉じたら、その場で保存する
    if (_saveTimer?.isActive ?? false) {
      _saveTimer!.cancel();
      _repository.saveNote(widget.date, _controller.text);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _controller,
          hintText: '例：断れなかったのは、嫌われたくなかったからかもしれない',
          minLines: 4,
          maxLines: 10,
          maxLength: ReflectionRepository.maxNoteLength,
          onChanged: _onChanged,
        ),
        if (_saved)
          Row(
            children: [
              const Icon(AppIcons.check, size: 16, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '保存しました',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
