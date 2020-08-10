import 'package:flutter/material.dart';

class FormattedText extends StatelessWidget {
  final String text;
  final Color color;
  final bool bold;

  FormattedText(this.text, {this.color = Colors.black, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontSize: 16,
          color: color,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal),
    );
  }
}
