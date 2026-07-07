import 'package:base_flutter_proj/core/base/base_pages/app_page_scaffold.dart';
import 'package:base_flutter_proj/core/components/colored_card_widget.dart';
import 'package:base_flutter_proj/core/components/files/app_file_item.dart';
import 'package:base_flutter_proj/core/components/files/app_file_picker_field.dart';
import 'package:base_flutter_proj/core/components/media/feed/media_feed_strip.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_content_mode.dart';
import 'package:base_flutter_proj/core/components/media/model/media_feed_item.dart';
import 'package:base_flutter_proj/core/components/media/picker/app_image_cropper.dart';
import 'package:base_flutter_proj/core/components/sharing/app_share_button.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
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
    final l10n = S.of(context);

    return AppPageScaffold(
      appBarConfig: AppPageAppBarConfig(title: l10n.demoMediaFilesTitle),
      body: ListView(
        padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
        children: [
          _SectionCard(
            title: l10n.demoPhotoSectionTitle,
            subtitle: l10n.demoPhotoSectionSubtitle,
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
            title: l10n.demoMixedSectionTitle,
            subtitle: l10n.demoMixedSectionSubtitle,
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
            title: l10n.demoReadOnlySectionTitle,
            subtitle: l10n.demoReadOnlySectionSubtitle,
            child: MediaFeedStrip(
              items: _readOnlyItems,
              editable: false,
              contentMode: MediaFeedContentMode.mixed,
              emptyPlaceholder: const _EmptyMediaPlaceholder(),
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          _SectionCard(
            title: l10n.demoFilesSectionTitle,
            subtitle: l10n.demoFilesSectionSubtitle,
            child: AppFilePickerField(
              files: _files,
              editable: true,
              fileType: FileType.custom,
              allowedExtensions: const ['pdf', 'doc', 'docx', 'txt', 'zip'],
              maxFiles: 5,
              onChanged: (files) => setState(() => _files = files),
              decoration: InputDecoration(
                labelText: l10n.demoAttachmentsLabel,
              ),
            ),
          ),
          const Gap(ThemeBuilder.defaultPadding),
          _SectionCard(
            title: l10n.demoShareSectionTitle,
            subtitle: l10n.demoShareSectionSubtitle,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppShareLinkButton(
                  url: 'https://example.com/demo',
                  text: l10n.demoShareLinkText,
                  label: l10n.shareLinkButton,
                ),
                AppShareButton(
                  text: 'base_flutter_proj',
                  label: l10n.shareButton,
                  builder: (context, onPressed) => OutlinedButton.icon(
                    onPressed: onPressed,
                    icon: const Icon(Icons.text_fields),
                    label: Text(l10n.demoShareTextButton),
                  ),
                ),
                if (_files.isNotEmpty)
                  AppShareButton(
                    filePaths: _files
                        .map((file) => file.resolvedPath)
                        .whereType<String>()
                        .toList(),
                    text: l10n.demoMediaFilesTitle,
                    label: l10n.shareButton,
                    builder: (context, onPressed) => FilledButton.icon(
                      onPressed: onPressed,
                      icon: const Icon(Icons.ios_share),
                      label: Text(l10n.demoShareFilesButton),
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
            label: Text(l10n.demoSyncMixedButton),
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
