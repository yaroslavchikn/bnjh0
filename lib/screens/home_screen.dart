import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import '../services/gallery_service.dart';
import '../widgets/custom_icons.dart';
import '../widgets/glass_button.dart';
import '../widgets/media_card.dart';
import 'photo_viewer_screen.dart';
import 'video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final List<AssetEntity> _assets = [];

  bool _loading = true;
  bool _hasAccess = false;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _hasAccess && !_loading) {
      _scan();
    }
  }

  Future<void> _bootstrap() async {
    final access = await GalleryService.requestAccess();

    if (!mounted) return;

    setState(() {
      _hasAccess = access;
    });

    if (access) {
      await _scan();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _scan() async {
    setState(() {
      _loading = true;
    });

    final assets = await GalleryService.scanGallery();

    if (!mounted) return;

    setState(() {
      _assets
        ..clear()
        ..addAll(assets);
      _loading = false;
    });
  }

  Future<void> _requestAccessAndScan() async {
    setState(() {
      _loading = true;
    });

    final access = await GalleryService.requestAccess();

    if (!mounted) return;

    setState(() {
      _hasAccess = access;
    });

    if (access) {
      await _scan();
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  List<AssetEntity> get _filtered {
    if (_tab == 0) return _assets;

    if (_tab == 1) {
      return _assets
          .where((asset) => asset.type == AssetType.image)
          .toList();
    }

    return _assets
        .where((asset) => asset.type == AssetType.video)
        .toList();
  }

  void _open(AssetEntity asset) {
    if (asset.type == AssetType.image) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PhotoViewerScreen(asset: asset),
        ),
      );
    } else if (asset.type == AssetType.video) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(asset: asset),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _background,
          SafeArea(
            child: Column(
              children: [
                _header,
                if (_hasAccess) _tabs,
                const SizedBox(height: 18),
                Expanded(
                  child: _body(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _background {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF050609),
              Color(0xFF0B1020),
              Color(0xFF050609),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget get _header {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MediaX',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Твоя галерея, фото и видео',
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color.fromRGBO(255, 255, 255, 0.45),
                  ),
                ),
              ],
            ),
          ),
          if (_loading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
              ),
            )
          else
            GlassButton(
              painter: const RefreshIconPainter(color: Colors.white),
              size: 52,
              onTap: () {
                if (_hasAccess) {
                  _scan();
                } else {
                  _requestAccessAndScan();
                }
              },
            ),
        ],
      ),
    );
  }

  Widget get _tabs {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          _TabButton(
            label: 'Все',
            painter: GridIconPainter(
              color: _tab == 0
                  ? Colors.white
                  : const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            selected: _tab == 0,
            onTap: () {
              setState(() {
                _tab = 0;
              });
            },
          ),
          _TabButton(
            label: 'Фото',
            painter: PhotoIconPainter(
              color: _tab == 1
                  ? Colors.white
                  : const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            selected: _tab == 1,
            onTap: () {
              setState(() {
                _tab = 1;
              });
            },
          ),
          _TabButton(
            label: 'Видео',
            painter: VideoIconPainter(
              color: _tab == 2
                  ? Colors.white
                  : const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            selected: _tab == 2,
            onTap: () {
              setState(() {
                _tab = 2;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _body() {
    if (_loading) {
      return _loadingBody;
    }

    if (!_hasAccess) {
      return _permissionDenied;
    }

    final filtered = _filtered;

    if (filtered.isEmpty) {
      return _emptyState;
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (context, index) {
        final asset = filtered[index];

        return MediaCard(
          asset: asset,
          onTap: () {
            _open(asset);
          },
        );
      },
    );
  }

  Widget get _loadingBody {
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
            'Сканирование галереи...',
            style: TextStyle(
              fontSize: 13,
              color: Color.fromRGBO(255, 255, 255, 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _permissionDenied {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomPaint(
              size: Size.square(72),
              painter: PhotoIconPainter(
                color: Color.fromRGBO(255, 255, 255, 0.18),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Нужен доступ к галерее',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Разреши доступ к фото и видео, чтобы приложение могло показать медиафайлы с телефона.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(255, 255, 255, 0.40),
              ),
            ),
            const SizedBox(height: 24),
            _WideButton(
              label: 'Разрешить доступ',
              painter: const AddIconPainter(color: Colors.white),
              primary: true,
              onTap: _requestAccessAndScan,
            ),
            const SizedBox(height: 10),
            _WideButton(
              label: 'Открыть настройки',
              painter: const GridIconPainter(color: Colors.white),
              onTap: () {
                GalleryService.openSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget get _emptyState {
    final hasAny = _assets.isNotEmpty;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomPaint(
              size: Size.square(72),
              painter: GridIconPainter(
                color: Color.fromRGBO(255, 255, 255, 0.16),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              hasAny ? 'В этой вкладке пусто' : 'Галерея пуста',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasAny
                  ? 'Переключи вкладку или обновить список.'
                  : 'На устройстве не найдено фото или видео.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color.fromRGBO(255, 255, 255, 0.40),
              ),
            ),
            const SizedBox(height: 24),
            GlassButton(
              painter: const RefreshIconPainter(color: Colors.white),
              primary: true,
              size: 56,
              onTap: _scan,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final CustomPainter painter;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.painter,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: selected
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF7C4DFF),
                        Color(0xFF00E5FF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: selected
                  ? null
                  : const Color.fromRGBO(255, 255, 255, 0.05),
              border: Border.all(
                color: selected
                    ? const Color.fromRGBO(255, 255, 255, 0.16)
                    : const Color.fromRGBO(255, 255, 255, 0.07),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPaint(
                  size: const Size.square(15),
                  painter: painter,
                ),
                const SizedBox(width: 7),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected
                        ? Colors.white
                        : const Color.fromRGBO(255, 255, 255, 0.55),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WideButton extends StatelessWidget {
  final String label;
  final CustomPainter painter;
  final VoidCallback onTap;
  final bool primary;

  const _WideButton({
    required this.label,
    required this.painter,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: primary
              ? const LinearGradient(
                  colors: [
                    Color(0xFF7C4DFF),
                    Color(0xFF00E5FF),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: primary ? null : const Color(0xFF181B26),
          border: Border.all(
            color: primary
                ? const Color.fromRGBO(255, 255, 255, 0.16)
                : const Color.fromRGBO(255, 255, 255, 0.08),
          ),
        ),
        child: Row(
          children: [
            CustomPaint(
              size: const Size.square(18),
              painter: painter,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
