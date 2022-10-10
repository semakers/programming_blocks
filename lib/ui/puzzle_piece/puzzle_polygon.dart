import 'package:flutter/material.dart';
import 'dart:math';

class PuzzlePolygon extends StatelessWidget {
  const PuzzlePolygon({
    Key? key,
    required this.sides,
    required this.size,
    required this.color,
    required this.leftPadding,
    this.withGradient = false,
  }) : super(key: key);

  final int sides;
  final double size;
  final Color color;
  final double leftPadding;
  final bool withGradient;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _MyPolygonClipper(
        sides: sides,
        size: size,
        leftPadding: leftPadding,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: withGradient ? null : color,
          gradient: withGradient
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    color,
                    Colors.white,
                  ],
                  stops: const [0.3, 1.0],
                )
              : null,
        ),
      ),
    );
  }
}

class _MyPolygonClipper extends CustomClipper<Path> {
  _MyPolygonClipper({
    required this.sides,
    required this.size,
    required this.leftPadding,
  });

  final int sides;
  final double size;
  final double leftPadding;

  @override
  Path getClip(Size size) {
    return createPolygonPath(
      sides,
      size,
    );
  }

  @override
  bool shouldReclip(_MyPolygonClipper oldClipper) {
    return oldClipper.sides != sides;
  }

  Path createPolygonPath(int sides, Size size) {
    final path = Path();
    final radius = size.width / 2;
    final angle = 2 * pi / sides;
    final startAngle = pi / 2 - angle / 2;

    final double widthCarry = sides == 3
        ? size.width * 0.2
        : sides == 4
            ? size.width * 0.1
            : 0;

    for (var i = 0; i < sides; i++) {
      final x = leftPadding +
          2 +
          widthCarry +
          size.width / 2 +
          radius * cos(startAngle + i * angle + (-90 * pi / 180));
      final y = size.width / 2 +
          radius * sin(startAngle + i * angle + (-90 * pi / 180));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.close();

    return path;
  }
}
