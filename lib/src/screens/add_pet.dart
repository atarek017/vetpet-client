import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/blueCircle.dart';
import '../widgets/background_container.dart';
import '../widgets/line_separator.dart';
import '../widgets/horizontal_radio.dart';
import '../scoped_models/pet_model.dart';
import '../enums/data_type.dart';
import '../providers/pet_provider.dart';

class AddPet extends StatefulWidget {
  @override
  _AddPetState createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  PetModel _petModel = PetModel();
  File _image;
  TextEditingController nameController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController breedController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController behaviourController = TextEditingController();
  TextEditingController vaccineDateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  PetProvider _petProvider = PetProvider();

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return ScopedModel<PetModel>(
      model: _petModel,
      child: Scaffold(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent(double screenWidth) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 20),
        Row(
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
        ),
        SizedBox(height: 30),
        Container(
          padding: EdgeInsets.symmetric(
              horizontal:
                  screenWidth < 600 ? screenWidth * 0.05 : screenWidth * 0.125),
          child: petCard(),
        ),
        SizedBox(height: 30),
        buildSubmitButton(),
        SizedBox(height: 20),
        buildCancelButton(),
        SizedBox(height: 40),
      ],
    );
  }

  FlatButton buildCancelButton() {
    return FlatButton(
        onPressed: () {},
        child: Text(
          'Cancel',
          style: TextStyle(fontSize: 20, color: Colors.grey),
        ));
  }

  Widget buildSubmitButton() {
    return ScopedModelDescendant<PetModel>(
        builder: (context, widget, PetModel model) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: MaterialButton(
            onPressed: () async {
              model.setName(nameController.text);
              model.setSize(sizeController.text);
              model.setBreed(breedController.text);
              model.setBirthDate(birthDateController.text);
              model.setBehaviour(behaviourController.text);
              model.setVaccineDate(vaccineDateController.text);
              model.setDescription(descriptionController.text);
              print(model.petData.toString());
              bool result = await _petProvider.addPet(model.getName(), model.getSpecies(),
                  model.getGender(), model.getSize());
              print('pet added : $result');
              if(result){
                Navigator.of(context).pop();
              }
            },
            child: Text(
              'Confirm',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.blue[900],
          ),
        ),
      );
    });
  }

  Future<String> getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    print('image path ${image.path}');
    return _image.path;
  }

  Widget petCard() {
    return ClipPath(
      clipper: CardCustomClipper(),
      child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 1475,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30),
                  Center(child: imageContainer()),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('name *'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: nameController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Name',
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 30),
                  LineSeparator(
                    color: Colors.grey,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('species *'),
                  ),
                  Container(
                    height: 80,
                    child: HorizontalRadio(DataType.Species, <RadioModel>[
                      RadioModel(false, 'Dog'),
                      RadioModel(false, 'Cat'),
                      RadioModel(false, 'Other')
                    ]),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('size *'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: sizeController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Size',
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('breed'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: breedController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Breed',
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('Gender'),
                  ),
                  Container(
                    height: 80,
                    child: HorizontalRadio(DataType.Gender, <RadioModel>[
                      RadioModel(false, 'Male'),
                      RadioModel(false, 'Femal')
                    ]),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('Neutered'),
                  ),
                  Container(
                    height: 80,
                    child: HorizontalRadio(DataType.Neutered, <RadioModel>[
                      RadioModel(false, 'Yes'),
                      RadioModel(false, 'No')
                    ]),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('Insured'),
                  ),
                  Container(
                    height: 80,
                    child: HorizontalRadio(DataType.Insured, <RadioModel>[
                      RadioModel(false, 'Yes'),
                      RadioModel(false, 'No'),
                    ]),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('date of birth'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: birthDateController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Date Of Birth',
                          suffixIcon: Icon(Icons.date_range),
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('behaviour'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: behaviourController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Behaviour',
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('last vaccination date'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: vaccineDateController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: 'Last Vaccination Date',
                          suffixIcon: Icon(Icons.date_range),
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: formattedTile('description'),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: 'Description',
                          labelStyle: TextStyle(fontSize: 20)),
                    ),
                  ),
                ],
              ),
              cardBreak(),
            ],
          )),
    );
  }

  Widget formattedTile(String text) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.start,
      style: TextStyle(
        color: Colors.blue[900],
        fontSize: 18,
      ),
    );
  }

  ClipRRect imageContainer() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 200,
        height: 200,
        child: ScopedModelDescendant<PetModel>(
            builder: (BuildContext context, Widget child, PetModel model) {
          return Stack(
            children: <Widget>[
              _image == null
                  ? Image.network(
                      'https://images.spot.im/v1/production/phj6czto7p709vbh7kel',
                      fit: BoxFit.fill,
                      width: 200,
                      height: 200)
                  : Image.file(File(_image.path),
                      fit: BoxFit.fill, width: 200, height: 200),
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.85)
                  ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter,
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 72),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 110),
                    IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () async {
                          print('get image');
                          await getImage();
                          model.setImage(_image.path);
                        }),
                    Text(
                      'Edit',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Align cardBreak() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
            color: Colors.blue[900],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            )),
      ),
    );
  }
}

class CardCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 320);
    path.quadraticBezierTo(30, 340, 0, 360);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 360);
    path.quadraticBezierTo(size.width - 30, 340, size.width, 320);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
