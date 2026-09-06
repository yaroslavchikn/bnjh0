import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../utils/asset_file.dart';
import '../utils/media_info.dart';
import '../widgets/custom_icons.dart';
import '../widgets/glass_button.dart';

class VideoPlayerScreen extends StatefulWidget {
  final AssetEntity asset;

  const VideoPlayerScreen({
    super.key,
    required this.asset,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController? _controller;

  bool _ready = false;
  bool _error = false;
  bool _controlsVisible = true;

  Timer? _hideTimer;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final file = await loadAssetFile(widget.asset);

    if (!mounted) return;

    if (file == null) {
      setState(() {
        _error = true;
      });
      return;
    }

    final controller = VideoPlayerController.file(file);
    _controller = controller;

    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();

      if (!mounted) return;

      setState(() {
        _ready = true;
        _duration = controller.value.duration;
      });

      controller.addListener(_onVideoChanged);
      _scheduleHide();
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = true;
        });
      }
    }
  }

  void _onVideoChanged() {
    final controller = _controller;

    if (controller == null || !controller.value.isInitialized) return;
    if (!mounted) return;

    if (controller.value.position != _position ||
        controller.value.duration != _duration) {
      setState(() {
        _position = controller.value.position;
        _duration = controller.value.duration;
      });
    }
  }

  void _scheduleHide() {
    _hideTimer?.cancel();

    if (_controller?.value.isPlaying ?? false) {
      _hideTimer = Timer(const Duration(seconds: 3), () {
        if (mounted && (_controller?.value.isPlaying ?? false)) {
          setState(() {
            _controlsVisible = false;
          });
        }
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    _scheduleHide();
  }

  void _togglePlay() {
    final controller = _controller;
    if (controller == null) return;

    setState(() {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });

    _scheduleHide();
  }

  void _seek(Duration delta) {
    final controller = _controller;
    if (controller == null) return;

    final target = _position + delta;

    final clamped = target < Duration.zero
        ? Duration.zero
        : target > _duration
            ? _duration
            : target;

    controller.seekTo(clamped);

    setState(() {
      _position = clamped;
    });

    _scheduleHide();
  }

  void _seekTo(double milliseconds) {
    final controller = _controller;
    if (controller == null) return;

    final target = Duration(milliseconds: milliseconds.round());
    controller.seekTo(target);

    setState(() {
      _position = target;
    });

    _scheduleHide();
  }

  double get _aspectRatio {
    final ratio = _controller?.value.aspectRatio ?? 16 / 9;

    if (ratio == 0 || ratio.isNaN || ratio.isInfinite) {
      return 16 / 9;
    }

    return ratio;
  }

  double get _sliderValue {
    final max = _duration.inMilliseconds.toDouble();
    if (max <= 0) return 0;

    final current = _position.inMilliseconds.toDouble();

    if (current < 0) return 0;
    if (current > max) return max;

    return current;
  }

  double get _sliderMax {
    final max = _duration.inMilliseconds.toDouble();
    return max <= 0 ? 1.0 : max;
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _controller?.removeListener(_onVideoChanged);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _error
          ? _buildError()
          : !_ready
              ? _buildLoading()
              : Stack(
                  children: [
                    GestureDetector(
                      onTap: _toggleControls,
                      child: Center(
                        child: AspectRatio(
                          aspectRatio: _aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _controlsVisible ? 1 : 0,
                      duration: const Duration(milliseconds: 180),
                      child: IgnorePointer(
                        ignoring: !_controlsVisible,
                        child: _buildControls(),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 54,
            height: 54,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: Color(0xFF00E5FF),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Загрузка видео...',
            style: TextStyle(
              fontSize: 13,
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomPaint(
            size: Size.square(40),
            painter: CloseIconPainter(
              color: Color.fromRGBO(255, 255, 255, 0.35),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Не удалось воспроизвести видео',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Файл повреждён или формат не поддерживается.',
            style: TextStyle(
              fontSize: 12,
              color: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
          const SizedBox(height: 18),
          GlassButton(
            painter: const BackIconPainter(color: Colors.white),
            size: 50,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Stack(
      children: [
        _topBar,
        Positioned(
          left: 16,
          right: 16,
          bottom: 18,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(11, 13, 20, 0.72),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: const Color.fromRGBO(255, 255, 255, 0.08),
              ),
            ),
            child: Column(
              children: [
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                      disabledThumbRadius: 7,
                      elevation: 0,
                      pressedElevation: 0,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 16,
                    ),
                    activeTrackColor: const Color(0xFF00E5FF),
                    inactiveTrackColor: const Color.fromRGBO(
                      255,
                      255,
                      255,
                      0.14,
                    ),
                    thumbColor: Colors.white,
                    overlayColor: const Color.fromRGBO(255, 255, 255, 0.12),
                  ),
                  child: Slider(
                    value: _sliderValue,
                    min: 0,
                    max: _sliderMax,
                    onChanged: (value) {
                      _seekTo(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    children: [
                      Text(
                        formatDuration(_position),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        formatDuration(_duration),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color.fromRGBO(255, 255, 255, 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GlassButton(
                      painter: const RewindIconPainter(color: Colors.white),
                      size: 50,
                      iconScale: 0.52,
                      onTap: () {
                        _seek(const Duration(seconds: -10));
                      },
                    ),
                    GlassButton(
                      painter: _controller!.value.isPlaying
                          ? const PauseIconPainter(color: Colors.white)
                          : const PlayIconPainter(color: Colors.white),
                      primary: true,
                      size: 64,
                      iconScale: 0.42,
                      onTap: _togglePlay,
                    ),
                    GlassButton(
                      painter: const ForwardIconPainter(color: Colors.white),
                      size: 50,
                      iconScale: 0.52,
                      onTap: () {
                        _seek(const Duration(seconds: 10));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _topBar {
    return Positioned(
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
    );
  }
}
