import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../utils/media_info.dart';
import 'custom_icons.dart';

class MediaCard extends StatelessWidget {
  final AssetEntity asset;
  final VoidCallback onTap;

  const MediaCard({
    super.key,
    required this.asset,
    required this.onTap,
  });

  bool get _isVideo => asset.type == AssetType.video;

  @override
  Widget build(BuildContext context) {
    final duration = mediaDuration(asset);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color.fromRGBO(255, 255, 255, 0.08),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.35),
              blurRadius: 18,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                child: AssetEntityImage(
                  asset,
                  isOriginal: false,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        const Color.fromRGBO(0, 0, 0, 0.72),
                      ],
                    ),
                  ),
                ),
              ),
              if (_isVideo)
                const Positioned.fill(
                  child: Center(
                    child: _VideoPlayBadge(),
                  ),
                ),
              Positioned(
                left: 12,
                right: 12,
                bottom: 12,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        mediaTitle(asset),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (_isVideo && duration > Duration.zero) ...[
                      const SizedBox(width: 8),
                      _DurationChip(duration: duration),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoPlayBadge extends StatelessWidget {
  const _VideoPlayBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.38),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.22),
        ),
      ),
      child: const Center(
        child: CustomPaint(
          size: Size.square(18),
          painter: PlayIconPainter(color: Colors.white),
        ),
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  final Duration duration;

  const _DurationChip({required this.duration});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 0, 0, 0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromRGBO(255, 255, 255, 0.14),
        ),
      ),
      child: Text(
        formatDuration(duration),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
