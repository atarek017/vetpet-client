import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: mCustomClipper(),
      child: Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.grey[200], Colors.grey[400]])
        ),
      ),
    );
  }
}

class mCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.7);

    path.quadraticBezierTo( size.width * .4, size.height * 0.8, size.width * 0.6, size.height * 0.55);
    path.quadraticBezierTo( size.width * 0.75, size.height * 0.35, size.width * 0.7, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
