import 'package:flutter/material.dart';

import 'package:base_flutter_proj/core/platform/files/app_pdf_preview_web.dart'
    if (dart.library.io) 'package:base_flutter_proj/core/platform/files/app_pdf_preview_io.dart'
    as implementation;

Widget appPdfPreview(String path) => implementation.appPdfPreview(path);
