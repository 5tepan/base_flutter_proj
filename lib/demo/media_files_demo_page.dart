import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/colored_card_widget.dart';
import 'package:base_flutter_proj/core/components/files/app_file_item.dart';
import 'package:base_flutter_proj/core/components/files/app_file_picker_field.dart';
import 'package:base_flutter_proj/core/components/media/app_image_cropper.dart';
import 'package:base_flutter_proj/core/components/media/media_feed_content_mode.dart';
import 'package:base_flutter_proj/core/components/media/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/media/media_feed_strip.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share_button.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Демо экран виджетов медиа, файлов и шаринга.
class MediaFilesDemoPage extends StatefulWidget {
  const MediaFilesDemoPage({super.key});

  @override
  State<MediaFilesDemoPage> createState() => _MediaFilesDemoPageState();
}

class _MediaFilesDemoPageState extends State<MediaFilesDemoPage> {
  List<MediaFeedItem> _photoItems = [];
  List<MediaFeedItem> _mixedItems = [];
  List<MediaFeedItem> _readOnlyItems = [];
  List<AppFileItem> _files = [];

  @override
  Widget build(BuildContext context) {
    return AppPageScaffold(
      appBarConfig: const AppPageAppBarConfig(title: 'Медиа и файлы'),
      body: ListView(
        padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
        children: [
          _SectionCard(
            title: 'Фото (редактируемая лента)',
            subtitle:
                'Только изображения. При добавлении открывается croppy для обрезки.',
            child: MediaFeedStrip(
              items: _photoItems,
              editable: true,
              contentMode: MediaFeedContentMode.photosOnly,
              maxItems: 5,
              cropConfig: const AppImageCropConfig(),
              onChanged: (items) => setState(() => _photoItems = items),
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          _SectionCard(
            title: 'Фото и видео (mixed)',
            subtitle:
                'Смешанная лента. С камеры — выбор фото или видео, из галереи — любой тип.',
            child: MediaFeedStrip(
              items: _mixedItems,
              editable: true,
              contentMode: MediaFeedContentMode.mixed,
              maxItems: 8,
              onChanged: (items) => setState(() => _mixedItems = items),
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          _SectionCard(
            title: 'Только просмотр',
            subtitle:
                'Те же элементы, что в mixed-ленте, но без кнопок добавления и удаления.',
            child: MediaFeedStrip(
              items: _readOnlyItems,
              editable: false,
              contentMode: MediaFeedContentMode.mixed,
              emptyPlaceholder: const _EmptyMediaPlaceholder(),
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          _SectionCard(
            title: 'Загрузка файлов',
            subtitle: 'PDF, документы и другие типы через file_picker.',
            child: AppFilePickerField(
              files: _files,
              editable: true,
              fileType: FileType.custom,
              allowedExtensions: const ['pdf', 'doc', 'docx', 'txt', 'zip'],
              maxFiles: 5,
              onChanged: (files) => setState(() => _files = files),
              decoration: const InputDecoration(
                labelText: 'Вложения',
              ),
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          _SectionCard(
            title: 'Шаринг',
            subtitle: 'share_plus — ссылка, текст и выбранные файлы.',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppShareLinkButton(
                  url: 'https://example.com/demo',
                  text: 'Демо ссылка из приложения',
                ),
                AppShareButton(
                  text: 'Текст для шаринга из base_flutter_proj',
                  label: 'Текст',
                  builder: (context, onPressed) => OutlinedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.text_fields),
                    label: const Text('Поделиться текстом'),
                  ),
                ),
                if (_files.isNotEmpty)
                  AppShareButton(
                    filePaths: _files
                        .map((file) => file.resolvedPath)
                        .whereType<String>()
                        .toList(),
                    text: 'Файлы из демо-экрана',
                    label: 'Файлы',
                    builder: (context, onPressed) => FilledButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(Icons.ios_share),
                      label: const Text('Поделиться файлами'),
                    ),
                  ),
              ],
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          OutlinedButton.icon(
            onPressed: _mixedItems.isEmpty
                ? null
                : () => setState(() => _readOnlyItems = List.of(_mixedItems)),
            icon: const Icon(Icons.sync),
            label: const Text('Скопировать mixed-ленту в режим просмотра'),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredCardWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: AppTextStyle.title),
          const Gap(4),
          Text(subtitle, style: AppTextStyle.small),
          const Gap(ThemeBuilder.defaultPadding),
          child,
        ],
      ),
    );
  }
}

class _EmptyMediaPlaceholder extends StatelessWidget {
  const _EmptyMediaPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Center(
        child: Icon(Icons.perm_media_outlined, color: AppColors.grey),
      ),
    );
  }
}
