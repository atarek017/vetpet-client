import 'package:flutter/material.dart';

import 'line_separator.dart';

class PetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CardCustomClipper(),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: 500,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Image.asset(
                  'assets/pics/dog.jpg',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 20),
                Text(
                  'Baxter',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(height: 30),
                LineSeparator(
                  color: Colors.grey,
                ),
                SizedBox(height: 20),
                Text(
                  'Information',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                buildInformationBlock(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(

                height: 12,
                decoration: BoxDecoration(
                    color: Colors.blue[900], borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                )),
              ),
            ),
          ],
        )
      ),
    );
  }

  /*

   */

  Padding buildInformationBlock() {
    return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Male',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Griffon',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Small',
                      style: TextStyle(color: Colors.grey, fontSize: 20),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Icons.graphic_eq,
                          color: Colors.grey,
                        ),
                        Text(
                          '7 KG',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.cake,
                          color: Colors.grey,
                        ),
                        Text(
                          'Griffon',
                          style: TextStyle(color: Colors.grey, fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

class CardCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 225);
    path.quadraticBezierTo(30, 250, 0, 275);
    path.lineTo(0, 500);
    path.lineTo(size.width, 500);
    path.lineTo(size.width, 275);
    path.quadraticBezierTo(size.width - 30, 250, size.width, 225);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    //  path.quadraticBezierTo(50, 220, 0, 230);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
