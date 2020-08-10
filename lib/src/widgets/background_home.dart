import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade100,
          child: Stack(
        children: <Widget>[
          Positioned(
            top: -60,
            left: -50,
            right: -20,
            child: ClipRRect(
              child: Container(
                width: MediaQuery.of(context).size.width+100 ,
                height: MediaQuery.of(context).size.width+100 ,
                color: Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(MediaQuery.of(context).size.width+100 ),
            ),
          ),
            Positioned(
            bottom: -20,
            right: -20,
            child: ClipRRect(
              child: Container(
                width: 100 ,
                height: 100 ,
                color: Colors.blue.shade100,
              ),
              borderRadius: BorderRadius.circular(100 ),
            ),
          ),
        ],
      ),
    );
  }
}

