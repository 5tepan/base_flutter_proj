import 'dart:async';

import 'package:base_flutter_proj/core/helpers/app_platform.dart';
import 'package:base_flutter_proj/core/helpers/assets_catalog.dart';
import 'package:base_flutter_proj/core/theme/theme_builder.dart';
import 'package:base_flutter_proj/core/helpers/widget_extensions/simple_padding_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorPage extends StatefulWidget {
  final String error;
  final FutureOr<void> Function() onRetry;

  const ErrorPage({required this.error, required this.onRetry, super.key});

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  bool isLoading = false;
  final backgroundColor = AppColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: ColoredBox(
        color: backgroundColor,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: _buildBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 4, child: _buildLogoImage(context)),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeBuilder.defaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.error,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).bottomPadding(ThemeBuilder.defaultPadding),
                if (isLoading)
                  _buildLoader(context, 0)
                else
                  _buildButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      style: const ButtonStyle(elevation: WidgetStatePropertyAll(0)),
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await widget.onRetry.call();
              setState(() {
                isLoading = false;
              });
            },
      child: const Text('Попробовать снова'),
    );
  }

  Widget _buildLogoImage(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.6,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipOval(child: Image.asset(AssetsCatalog.logo)),
        ),
      ),
    );
  }

  Widget _buildLoader(BuildContext context, double? margin) {
    return Center(
      child: AppPlatform.isAndroid
          ? const SizedBox(
              height: 40.0,
              width: 40.0,
              child: CircularProgressIndicator(),
            )
          : const CupertinoActivityIndicator(radius: 25),
    );
  }
}
