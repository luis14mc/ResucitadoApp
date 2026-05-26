import 'package:flutter/material.dart';

/// Widget que crea un efecto de onda decorativa
///
/// Útil para transiciones suaves entre secciones con diferentes colores de fondo
class WaveClipper extends StatelessWidget {
  final Color color;
  final double height;

  const WaveClipper({
    Key? key,
    this.color = Colors.white,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperPath(),
      child: Container(
        color: color,
        width: double.infinity,
        height: height,
      ),
    );
  }
}

/// Custom clipper para crear el efecto de onda
class WaveClipperPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 40,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
