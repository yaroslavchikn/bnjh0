import 'package:flutter/material.dart';

class GlassButton extends StatefulWidget {
  final CustomPainter painter;
  final VoidCallback? onTap;
  final double size;
  final double iconScale;
  final bool primary;
  final bool enabled;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;

  const GlassButton({
    super.key,
    required this.painter,
    this.onTap,
    this.size = 52,
    this.iconScale = 0.44,
    this.primary = false,
    this.enabled = true,
    this.borderRadius,
    this.padding,
  });

  @override
  State<GlassButton> createState() => _GlassButtonState();
}

class _GlassButtonState extends State<GlassButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (mounted) {
      setState(() {
        _pressed = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final radius =
        widget.borderRadius ?? BorderRadius.circular(widget.size * 0.32);

    return Opacity(
      opacity: widget.enabled ? 1 : 0.45,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
        onTapCancel: widget.enabled ? () => _setPressed(false) : null,
        onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: Container(
            width: widget.size,
            height: widget.size,
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: widget.primary
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF7C4DFF),
                        Color(0xFF00E5FF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              color: widget.primary
                  ? null
                  : const Color.fromRGBO(27, 31, 45, 0.82),
              border: Border.all(
                color: widget.primary
                    ? const Color.fromRGBO(255, 255, 255, 0.22)
                    : const Color.fromRGBO(255, 255, 255, 0.12),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.primary
                      ? const Color.fromRGBO(124, 77, 255, 0.35)
                      : const Color.fromRGBO(0, 0, 0, 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: CustomPaint(
                size: Size.square(widget.size * widget.iconScale),
                painter: widget.painter,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
