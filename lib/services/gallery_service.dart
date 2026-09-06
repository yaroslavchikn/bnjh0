import 'package:photo_manager/photo_manager.dart';

class GalleryService {
  static Future<bool> requestAccess() async {
    try {
      dynamic manager = PhotoManager;
      dynamic state;

      try {
        state = await manager.requestPermissionExtend();
      } catch (_) {
        state = await manager.requestPermission();
      }

      if (state is bool) {
        return state;
      }

      try {
        final bool hasAccess = state.hasAccess as bool;
        if (hasAccess) return true;
      } catch (_) {}

      final text = state.toString().toLowerCase();
      return text.contains('authorized') || text.contains('limited');
    } catch (_) {
      return false;
    }
  }

  static Future<void> openSettings() async {
    try {
      dynamic manager = PhotoManager;

      try {
        await manager.openSetting();
      } catch (_) {
        await manager.openSettings();
      }
    } catch (_) {}
  }

  static Future<List<AssetEntity>> scanGallery() async {
    final albums = await _getAlbums();

    for (final album in albums) {
      final count = await _getCount(album);

      if (count > 0) {
        return _fetchAllAssets(album, count);
      }
    }

    return [];
  }

  static Future<List<AssetPathEntity>> _getAlbums() async {
    dynamic manager = PhotoManager;

    final attempts = <Future<dynamic> Function()>[
      () => manager.getAssetListList(
            type: RequestType.common,
            onlyAll: true,
          ),
      () => manager.getAssetListList(
            type: RequestType.common,
          ),
      () => manager.getAssetListList(),
      () => manager.getAssetPathList(
            type: RequestType.common,
            onlyAll: true,
          ),
      () => manager.getAssetPathList(
            type: RequestType.common,
          ),
      () => manager.getAssetPathList(),
    ];

    for (final attempt in attempts) {
      try {
        final result = await attempt();

        if (result is List && result.isNotEmpty) {
          return List<AssetPathEntity>.from(result);
        }

        if (result is List) {
          continue;
        }
      } catch (_) {}
    }

    return [];
  }

  static Future<int> _getCount(AssetPathEntity album) async {
    dynamic dynamicAlbum = album;

    try {
      final count = await dynamicAlbum.assetCountAsync;
      return (count as int?) ?? 0;
    } catch (_) {}

    try {
      final count = await dynamicAlbum.assetCount;
      return (count as int?) ?? 0;
    } catch (_) {}

    return 0;
  }

  static Future<List<AssetEntity>> _fetchAllAssets(
    AssetPathEntity album,
    int count,
  ) async {
    final assets = <AssetEntity>[];
    const pageSize = 200;

    dynamic dynamicAlbum = album;

    var page = 0;

    while (assets.length < count) {
      final end = assets.length + pageSize > count
          ? count
          : assets.length + pageSize;

      List? batch;

      try {
        final result = await dynamicAlbum.getAssetListRange(
          start: assets.length,
          end: end,
        );

        if (result is List) {
          batch = result;
        }
      } catch (_) {
        try {
          final result = await dynamicAlbum.getAssetListPaged(
            page: page,
            size: pageSize,
          );

          if (result is List) {
            batch = result;
          }
        } catch (_) {
          break;
        }
      }

      if (batch == null || batch.isEmpty) {
        break;
      }

      assets.addAll(List<AssetEntity>.from(batch));
      page++;
    }

    return assets;
  }
}
