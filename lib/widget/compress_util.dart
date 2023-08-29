import 'dart:io';

import 'package:flutter_native_image/flutter_native_image.dart';

Future<File> compressFile(File file) async {
  File compressedFile = await FlutterNativeImage.compressImage(
    file.path,
    quality: 30,
  );
  return compressedFile;
}
