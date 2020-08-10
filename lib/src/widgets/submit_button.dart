import 'package:flutter/material.dart';

Widget buildSubmitButton(double _width, double _height) {
  return Container(
    width: _width * 0.8,
    height: _height,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: MaterialButton(
        onPressed: null,
        child: Text(
          'Confirm',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        color: Colors.blue[900],
        minWidth: _width * 0.8,
      ),
    ),
  );
}
