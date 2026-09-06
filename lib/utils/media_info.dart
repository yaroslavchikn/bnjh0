import 'package:photo_manager/photo_manager.dart';

String mediaTitle(AssetEntity asset) {
  dynamic dynamicAsset = asset;

  try {
    final title = dynamicAsset.title;

    if (title != null && title.toString().trim().isNotEmpty) {
      return title.toString();
    }
  } catch (_) {}

  try {
    final id = asset.id;

    if (id.trim().isNotEmpty) {
      return id;
    }
  } catch (_) {}

  return asset.type == AssetType.video ? 'Видео' : 'Фото';
}

Duration mediaDuration(AssetEntity asset) {
  dynamic dynamicAsset = asset;

  try {
    final value = dynamicAsset.videoDuration;

    if (value is Duration) {
      return value;
    }

    if (value is int) {
      return Duration(seconds: value);
    }
  } catch (_) {}

  try {
    final value = dynamicAsset.duration;

    if (value is Duration) {
      return value;
    }

    if (value is int && value > 0) {
      return Duration(seconds: value);
    }
  } catch (_) {}

  return Duration.zero;
}

String formatDuration(Duration duration) {
  final hours = duration.inHours.toString().padLeft(2, '0');
  final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

  if (hours == '00') {
    return '$minutes:$seconds';
  }

  return '$hours:$minutes:$seconds';
}
