import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../../../providers/repository_providers.dart';
import '../../../repositories/vision_repository.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/selectable_value_chip.dart';

Future<void> showValueSelectSheet(
  BuildContext context, {
  required List<SelectedValue> current,
}) async {
  // Widgetの外のためrefがない。そのためcontextから探してrepositoryを取得
  final repository = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(visionRepositoryProvider);
  final selection = _ValueSelection(repository: repository, current: current);
  await showAppBottomSheet<void>(
    context: context,
    title: '大切にしたい価値観を選ぶ',
    child: _ValueGrid(selection: selection),
    footer: _ValueFooter(selection: selection),
  );
  selection.dispose();
}

class _ValueSelection extends ChangeNotifier {
  _ValueSelection({required this.repository, required this.current})
    : names = current.map((v) => v.name).toSet();

  final VisionRepository repository;
  final List<SelectedValue> current;
  final Set<String> names;
  String? message;
  bool saving = false;

  // 候補＋候補にない保存済みの言葉
  List<String> get options => [
    ...repository.valueCandidates,
    ...current
        .map((v) => v.name)
        .where((n) => !repository.valueCandidates.contains(n)),
  ];

  void toggle(String name) {
    if (names.contains(name)) {
      names.remove(name);
      message = null;
    } else if (names.length >= VisionRepository.maxValues) {
      message =
          '価値観は${VisionRepository.maxValues}個までです。'
          '入れ替える時は、選択を外してください。';
    } else {
      names.add(name);
      message = null;
    }
    notifyListeners();
  }

  Future<bool> save() async {
    saving = true;
    message = null;
    notifyListeners();

    for (final v in current.where((v) => !names.contains(v.name))) {
      await repository.deleteValue(v.id);
    }
    final already = current.map((v) => v.name).toSet();
    for (final name in options.where(
      (n) => names.contains(n) && !already.contains(n),
    )) {
      if (!await repository.addValue(name)) {
        saving = false;
        message = '保存できませんでした。もう一度お試しください。';
        notifyListeners();
        return false;
      }
    }
    return true;
  }
}

class _ValueGrid extends StatelessWidget {
  const _ValueGrid({required this.selection});

  final _ValueSelection selection;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: selection,
      builder: (context, _) {
        return LayoutBuilder(
          builder: (context, constraints) {
            const columns = 3;
            const gap = AppSpacing.sm;
            final width =
                (constraints.maxWidth - gap * (columns - 1)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final name in selection.options)
                  SizedBox(
                    width: width,
                    child: SelectableValueChip(
                      label: name,
                      selected: selection.names.contains(name),
                      onTap: () => selection.toggle(name),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _ValueFooter extends StatelessWidget {
  const _ValueFooter({required this.selection});

  final _ValueSelection selection;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: selection,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${selection.names.length} / ${VisionRepository.maxValues}',
              textAlign: TextAlign.end,
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (selection.message != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                selection.message!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: '保存する',
              isLoading: selection.saving,
              onPressed: () async {
                final saved = await selection.save();
                if (saved && context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
