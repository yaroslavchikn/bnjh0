import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

Future<File?> loadAssetFile(AssetEntity asset) async {
  dynamic dynamicAsset = asset;

  try {
    final file = await dynamicAsset.originFile;
    if (file is File) return file;
  } catch (_) {}

  try {
    final file = await dynamicAsset.file;
    if (file is File) return file;
  } catch (_) {}

  return null;
}
