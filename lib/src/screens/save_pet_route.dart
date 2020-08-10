import 'package:flutter/material.dart';

import '../widgets/blueCircle.dart';
import '../widgets/background_container.dart';
import '../widgets/pet_card.dart';

class SavePetRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget>[
            BackgroundContainer(),
            Positioned(
              top: _height * 0.8,
              left: _width * 0.65,
              child: BlueCircle(),
            ),
            buildContent(_width),
            buildSubmitButton(_width, _height,context),
          ],
        ),
      ),
    );
  }

  Widget buildContent(double screenWidth) {
    return ListView(
      children: <Widget>[
        buildCloseButton(),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Save your pet',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Save your pet to your account for easier selection next time.',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 600
                    ? screenWidth * 0.05
                    : screenWidth * 0.125),
            child: PetCard(),
        ),
        SizedBox(height: 10),
        SizedBox(height: 150),
      ],
    );
  }

  Align buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
            icon: Icon(
              Icons.close,
              size: 50,
            ),
            onPressed: () {
              /* TODO add action*/
            }),
      ),
    );
  }

  Positioned buildSubmitButton(double _width, double _height,context) {
    return Positioned(
      left: _width * 0.45,
      top: _height * 0.85,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);

        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,

      ),
    );
  }
}
