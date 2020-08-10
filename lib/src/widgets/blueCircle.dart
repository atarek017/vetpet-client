import 'package:flutter/material.dart';

class BlueCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        child: Container(
          color: Colors.blueAccent[100].withOpacity(0.5),
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
