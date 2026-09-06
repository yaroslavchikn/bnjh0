import 'dart:math' as math;

import 'package:flutter/material.dart';

class PlayIconPainter extends CustomPainter {
  final Color color;

  const PlayIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.26, size.height * 0.16)
      ..lineTo(size.width * 0.86, size.height * 0.50)
      ..lineTo(size.width * 0.26, size.height * 0.84)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PlayIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class PauseIconPainter extends CustomPainter {
  final Color color;

  const PauseIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final barWidth = size.width * 0.16;
    final radius = size.width * 0.05;

    final left = Rect.fromLTWH(
      size.width * 0.28,
      size.height * 0.18,
      barWidth,
      size.height * 0.64,
    );

    final right = Rect.fromLTWH(
      size.width * 0.56,
      size.height * 0.18,
      barWidth,
      size.height * 0.64,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(left, Radius.circular(radius)),
      paint,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(right, Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant PauseIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class BackIconPainter extends CustomPainter {
  final Color color;

  const BackIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.11;

    final path = Path()
      ..moveTo(size.width * 0.64, size.height * 0.18)
      ..lineTo(size.width * 0.30, size.height * 0.50)
      ..lineTo(size.width * 0.64, size.height * 0.82);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant BackIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class CloseIconPainter extends CustomPainter {
  final Color color;

  const CloseIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.11;

    final path = Path()
      ..moveTo(size.width * 0.24, size.height * 0.24)
      ..lineTo(size.width * 0.76, size.height * 0.76)
      ..moveTo(size.width * 0.76, size.height * 0.24)
      ..lineTo(size.width * 0.24, size.height * 0.76);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CloseIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class AddIconPainter extends CustomPainter {
  final Color color;

  const AddIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.11;

    final path = Path()
      ..moveTo(size.width * 0.50, size.height * 0.18)
      ..lineTo(size.width * 0.50, size.height * 0.82)
      ..moveTo(size.width * 0.18, size.height * 0.50)
      ..lineTo(size.width * 0.82, size.height * 0.50);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant AddIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class GridIconPainter extends CustomPainter {
  final Color color;

  const GridIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final cell = size.width * 0.34;
    final gap = size.width * 0.10;
    final radius = size.width * 0.09;

    final offsets = [
      Offset(gap, gap),
      Offset(size.width - gap - cell, gap),
      Offset(gap, size.height - gap - cell),
      Offset(size.width - gap - cell, size.height - gap - cell),
    ];

    for (final offset in offsets) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(offset.dx, offset.dy, cell, cell),
          Radius.circular(radius),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant GridIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class PhotoIconPainter extends CustomPainter {
  final Color color;

  const PhotoIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.07;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      size.width * 0.08,
      size.height * 0.16,
      size.width * 0.84,
      size.height * 0.68,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.12)),
      stroke,
    );

    canvas.drawCircle(
      Offset(size.width * 0.33, size.height * 0.36),
      size.width * 0.06,
      fill,
    );

    final path = Path()
      ..moveTo(size.width * 0.14, size.height * 0.70)
      ..lineTo(size.width * 0.40, size.height * 0.42)
      ..lineTo(size.width * 0.58, size.height * 0.60)
      ..lineTo(size.width * 0.70, size.height * 0.48)
      ..lineTo(size.width * 0.86, size.height * 0.70);

    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant PhotoIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class VideoIconPainter extends CustomPainter {
  final Color color;

  const VideoIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.07;

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      size.width * 0.08,
      size.height * 0.20,
      size.width * 0.84,
      size.height * 0.60,
    );

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(size.width * 0.12)),
      stroke,
    );

    final path = Path()
      ..moveTo(
        rect.left + rect.width * 0.36,
        rect.top + rect.height * 0.28,
      )
      ..lineTo(
        rect.left + rect.width * 0.72,
        rect.top + rect.height * 0.50,
      )
      ..lineTo(
        rect.left + rect.width * 0.36,
        rect.top + rect.height * 0.72,
      )
      ..close();

    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant VideoIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class RewindIconPainter extends CustomPainter {
  final Color color;

  const RewindIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final width = size.width * 0.32;

    void triangle(double left) {
      final path = Path()
        ..moveTo(left + width, size.height * 0.20)
        ..lineTo(left, size.height * 0.50)
        ..lineTo(left + width, size.height * 0.80)
        ..close();

      canvas.drawPath(path, paint);
    }

    triangle(size.width * 0.10);
    triangle(size.width * 0.50);
  }

  @override
  bool shouldRepaint(covariant RewindIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class ForwardIconPainter extends CustomPainter {
  final Color color;

  const ForwardIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final width = size.width * 0.32;

    void triangle(double left) {
      final path = Path()
        ..moveTo(left, size.height * 0.20)
        ..lineTo(left + width, size.height * 0.50)
        ..lineTo(left, size.height * 0.80)
        ..close();

      canvas.drawPath(path, paint);
    }

    triangle(size.width * 0.14);
    triangle(size.width * 0.54);
  }

  @override
  bool shouldRepaint(covariant ForwardIconPainter oldDelegate) =>
      oldDelegate.color != color;
}

class RefreshIconPainter extends CustomPainter {
  final Color color;

  const RefreshIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = size.width * 0.09;

    final rect = Rect.fromLTWH(
      size.width * 0.18,
      size.height * 0.18,
      size.width * 0.64,
      size.height * 0.64,
    );

    canvas.drawArc(
      rect,
      -0.15 * math.pi,
      1.65 * math.pi,
      false,
      stroke,
    );

    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.74, size.height * 0.10)
      ..lineTo(size.width * 0.94, size.height * 0.20)
      ..lineTo(size.width * 0.76, size.height * 0.32)
      ..close();

    canvas.drawPath(path, fill);
  }

  @override
  bool shouldRepaint(covariant RefreshIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
