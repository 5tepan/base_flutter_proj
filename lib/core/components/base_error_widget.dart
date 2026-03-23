import 'package:base_flutter_proj/core/helpers/widget_extensions/simple_padding_extension.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:flutter/material.dart';

class BaseErrorWidget extends StatefulWidget {
  final VoidCallback onPressedButton;
  final String? image;
  final String titleError;
  final String textError;
  final String textButton;

  const BaseErrorWidget({
    required this.onPressedButton,
    super.key,
    this.image,
    this.titleError = 'Ошибка загрузки данных',
    this.textError = 'Данные не были загружены, пожалуйста, попробуйте еще раз',
    this.textButton = 'Попробовать снова',
  });

  @override
  State<BaseErrorWidget> createState() => _BaseErrorWidgetState();
}

class _BaseErrorWidgetState extends State<BaseErrorWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeBuilder.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.image != null)
              Image(image: AssetImage(widget.image!)).bottomPadding(30.0),
            _buildErrorContent(context).bottomPadding(30.0),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.titleError,
          textAlign: TextAlign.center,
          style: AppTextStyle.title.copyWith(fontSize: 20.0),
        ).bottomPadding(16.0),
        Text(
          widget.textError,
          textAlign: TextAlign.center,
          style: AppTextStyle.body.copyWith(fontSize: 13.0),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
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
      child: Text(widget.textButton),
    );
  }
}
