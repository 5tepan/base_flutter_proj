import 'package:base_flutter_proj/core/errors/app_error_code.dart';
import 'package:base_flutter_proj/core/helpers/widget_extensions/simple_padding_extension.dart';
import 'package:base_flutter_proj/core/l10n/error_localizer.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/generated/l10n.dart';
import 'package:flutter/material.dart';

class BaseErrorWidget extends StatefulWidget {
  final VoidCallback onPressedButton;
  final String? image;
  final String? titleError;
  final String? textError;
  final String? textButton;

  const BaseErrorWidget({
    required this.onPressedButton,
    super.key,
    this.image,
    this.titleError,
    this.textError,
    this.textButton,
  });

  factory BaseErrorWidget.fromError({
    required AppErrorCode errorCode,
    required VoidCallback onPressedButton,
    String? serverMessage,
    Key? key,
    String? image,
    String? titleError,
    String? textButton,
  }) {
    final message = ErrorLocalizer.message(
      errorCode,
      serverMessage: serverMessage,
    );
    return BaseErrorWidget(
      key: key,
      onPressedButton: onPressedButton,
      image: image,
      titleError: titleError,
      textError: message,
      textButton: textButton,
    );
  }

  @override
  State<BaseErrorWidget> createState() => _BaseErrorWidgetState();
}

class _BaseErrorWidgetState extends State<BaseErrorWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.image != null)
              Image(image: AssetImage(widget.image!)).bottomPadding(30.0),
            _buildErrorContent(context, l10n).bottomPadding(30.0),
            _buildButton(context, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, S l10n) {
    return Column(
      children: [
        Text(
          widget.titleError ?? l10n.errorLoadingTitle,
          textAlign: TextAlign.center,
          style: AppTextStyle.title.copyWith(fontSize: 20.0),
        ).bottomPadding(16.0),
        Text(
          widget.textError ?? l10n.errorLoadingText,
          textAlign: TextAlign.center,
          style: AppTextStyle.body.copyWith(fontSize: 13.0),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context, S l10n) {
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              widget.onPressedButton.call();
              setState(() {
                isLoading = false;
              });
            },
      child: Text(widget.textButton ?? l10n.tryAgain),
    );
  }
}
