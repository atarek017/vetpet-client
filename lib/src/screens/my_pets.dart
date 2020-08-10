import 'package:flutter/material.dart';

import '../widgets/blueCircle.dart';
import '../widgets/background_container.dart';
import '../providers/pet_provider.dart';
import '../models/pets.dart';
import 'add_pet.dart';

class MyPets extends StatefulWidget {
  @override
  _MyPetsState createState() => _MyPetsState();
}

class _MyPetsState extends State<MyPets> {
  PetProvider _petProvider = PetProvider();

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
          buildBody(),
        ],
      ),
    ));
  }

  Column buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 35),
        buildCustomAppBar(),
        SizedBox(height: 50),
        Center(child: buildNotificationPanel()),
        SizedBox(height: 30),
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Edit List',
                textAlign: TextAlign.start, style: TextStyle(fontSize: 18))),
        SizedBox(height: 30),
        Expanded(
          child: FutureBuilder(
              future: _petProvider.fetchPets(),
              builder: (context, AsyncSnapshot<List<Pets>> snapShot) {
                if (snapShot.connectionState == ConnectionState.done) {
                  if(snapShot.data == null || snapShot.data.isEmpty){
                    return Center(child: Text('You have no Pets added'),);
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListView.builder(
                          itemCount: snapShot.data.length,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return petCard(snapShot.data[index]);
                          }),
                      SizedBox(height: 10),
                      buildAppPetButton(),
                      SizedBox(height: 30),
                    ],
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ],
    );
  }

  Container buildNotificationPanel() {
    return Container(
      width: 350,
      height: 100,
      decoration: BoxDecoration(
          color: Colors.blue[900], borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 300,
        height: 95,
        margin: EdgeInsets.fromLTRB(15, 2, 2, 2),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Icon(Icons.info_outline, size: 40, color: Colors.black),
            SizedBox(width: 10),
            Expanded(
                child: Container(
              child: Text(
                'You have recently added a new Pet Tap to Complete Baxter\'s Profile',
                style: TextStyle(fontSize: 16),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Row buildCustomAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_backspace, color: Colors.black)),
        SizedBox(width: 20),
        Icon(Icons.pets, color: Colors.black),
        SizedBox(width: 10),
        Text('My Pets', style: TextStyle(color: Colors.black, fontSize: 20))
      ],
    );
  }

  Widget buildAppPetButton() {
    return InkWell(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => AddPet()));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 200),
        child: Card(
          child: Container(
            width: 80,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[Text('Add new Pet'), Icon(Icons.add)],
            ),
          ),
        ),
      ),
    );
  }

  Widget petCard(Pets pet) {
    return Dismissible(
      key: Key(pet.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        // TODO delete
      },
      background: Container(
          alignment: AlignmentDirectional.centerStart,
          padding: EdgeInsets.only(left: 30),
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 18,
            child: Icon(
              Icons.close,
              color: Colors.white,
            ),
          )),
      child: ClipPath(
        clipper: MyCustomClipper(),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          color: Colors.white,
          child: Container(
              width: 350,
              height: 100,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 20),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(pet.imgUrl))),
                        ),
                        SizedBox(width: 20),
                        Text(
                          pet.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Icon(Icons.arrow_forward_ios),
                    ),
                    alignment: Alignment.centerRight,
                  )
                ],
              )),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width * 0.63, 0);
    path.quadraticBezierTo(size.width *0.7, 40, size.width *0.77, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width * 0.77, size.height);
    path.quadraticBezierTo(size.width *0.7, size.height - 40, size.width *0.63, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
