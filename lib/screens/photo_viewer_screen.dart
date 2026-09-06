import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/asset_file.dart';
import '../utils/media_info.dart';
import '../widgets/custom_icons.dart';
import '../widgets/glass_button.dart';

class PhotoViewerScreen extends StatefulWidget {
  final AssetEntity asset;

  const PhotoViewerScreen({
    super.key,
    required this.asset,
  });

  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late Future<File?> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = loadAssetFile(widget.asset);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          FutureBuilder<File?>(
            future: _fileFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final file = snapshot.data;

              if (file == null) {
                return const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomPaint(
                        size: Size.square(36),
                        painter: CloseIconPainter(
                          color: Color.fromRGBO(255, 255, 255, 0.35),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Не удалось открыть изображение',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.55),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return PhotoView(
                imageProvider: FileImage(file),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.black,
                ),
                initialScale: PhotoViewComputedScale.contained,
                minScale: PhotoViewComputedScale.contained * 0.85,
                maxScale: PhotoViewComputedScale.covered * 3.5,
                enableRotation: false,
              );
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    GlassButton(
                      painter: const BackIconPainter(color: Colors.white),
                      size: 46,
                      onTap: () {
                        Navigator.of(context).maybePop();
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(11, 13, 20, 0.56),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color.fromRGBO(255, 255, 255, 0.08),
                          ),
                        ),
                        child: Text(
                          mediaTitle(widget.asset),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
