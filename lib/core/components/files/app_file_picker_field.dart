import 'package:base_flutter_proj/core/components/files/app_file_item.dart';
import 'package:base_flutter_proj/core/components/files/app_file_list_view.dart';
import 'package:base_flutter_proj/core/components/files/app_file_utils.dart';
import 'package:base_flutter_proj/core/components/media/app_media_picker.dart';
import 'package:base_flutter_proj/core/debug/logger.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

typedef AppFilePickerButtonBuilder =
    Widget Function(BuildContext context, VoidCallback onPressed);

/// Поле выбора файлов с опциональным редактированием списка.
class AppFilePickerField extends StatelessWidget {
  const AppFilePickerField({
    super.key,
    required this.files,
    this.onChanged,
    this.editable = true,
    this.fileType = FileType.any,
    this.allowedExtensions,
    this.maxFiles,
    this.allowMultiple = true,
    this.pickButtonLabel = 'Выбрать файлы',
    this.style = const AppFileListStyle(),
    this.decoration,
    this.pickButtonBuilder,
    this.listTileBuilder,
    this.emptyBuilder,
    this.allowShare = true,
    this.allowView = true,
    this.withData = false,
    this.withReadStream = false,
  });

  final List<AppFileItem> files;
  final ValueChanged<List<AppFileItem>>? onChanged;
  final bool editable;
  final FileType fileType;
  final List<String>? allowedExtensions;
  final int? maxFiles;
  final bool allowMultiple;
  final String pickButtonLabel;
  final AppFileListStyle style;
  final InputDecoration? decoration;
  final AppFilePickerButtonBuilder? pickButtonBuilder;
  final AppFileListTileBuilder? listTileBuilder;
  final WidgetBuilder? emptyBuilder;
  final bool allowShare;
  final bool allowView;
  final bool withData;
  final bool withReadStream;

  bool get _canPickMore =>
      editable &&
      onChanged != null &&
      (maxFiles == null || files.length < maxFiles!);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (decoration?.labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              decoration!.labelText!,
              style: decoration!.floatingLabelStyle ?? AppTextStyle.body,
            ),
          ),
        AppFileListView(
          files: files,
          onChanged: onChanged,
          editable: editable,
          style: style,
          emptyBuilder: emptyBuilder,
          tileBuilder: listTileBuilder,
          allowShare: allowShare,
          allowView: allowView,
        ),
        if (_canPickMore) ...[
          const SizedBox(height: ThemeBuilder.defaultSmallPadding),
          pickButtonBuilder?.call(context, () => _pickFiles(context)) ??
              OutlinedButton.icon(
                onPressed: () => _pickFiles(context),
                icon: const Icon(Icons.attach_file),
                label: Text(pickButtonLabel),
              ),
        ],
      ],
    );
  }

  Future<void> _pickFiles(BuildContext context) async {
    if (onChanged == null) {
      return;
    }

    try {
      final result = await FilePicker.pickFiles(
        type: fileType,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: withData,
        withReadStream: withReadStream,
      );
      if (result == null || result.files.isEmpty) {
        return;
      }

      final remainingSlots = maxFiles == null
          ? result.files.length
          : (maxFiles! - files.length).clamp(0, result.files.length);

      final picked = <AppFileItem>[];
      for (final platformFile in result.files.take(remainingSlots)) {
        final path = platformFile.path;
        if (path == null) {
          continue;
        }

        picked.add(
          AppFileItem(
            id: AppMediaPicker.createItemId(),
            name: platformFile.name,
            localPath: path,
            sizeBytes: platformFile.size,
            mimeType: AppFileUtils.guessMimeType(path: path, name: platformFile.name),
          ),
        );
      }

      if (picked.isEmpty) {
        return;
      }

      onChanged!([...files, ...picked]);
    } catch (error, stackTrace) {
      CustomLogger.warning('Не удалось выбрать файлы: $error');
      CustomLogger.verbose('$stackTrace');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось выбрать файлы')),
        );
      }
    }
  }
}
