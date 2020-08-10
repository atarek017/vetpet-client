import 'package:flutter/material.dart';
import '../fonts.dart';
import '../widgets/radio_buton.dart';
import '../providers/pet_provider.dart';
import 'dart:async';

class SaveYourPet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SaveYourPetState();
  }
}

class SaveYourPetState extends State<SaveYourPet> {
  String name = '';
  String size = '';
  String breed = '';
  String specie = '';
  int  gender = 1;
  PetProvider _petProvider=new PetProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Pets",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 10, right: 10),
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Text(
            "Save your pet",
            style: font1,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
              "Save your pet to your account for easier slection next time. fields with mandatory"),
          SizedBox(
            height: 10,
          ),
          Center(
            child: CircleAvatar(
              backgroundColor: Colors.brown,
              child: Text(
                "AH",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'Name*',
            ),
            onChanged: (String value) {
              setState(() {
                name = value;
              });
              print(name);
            },
          ),
          SizedBox(
            height: 5,
          ),
          Text("SPECIES*"),
          RadioButton(
            radio: 1,
            onTap: getSelectedSpecie,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'size*',
            ),
            onChanged: (String value) {
              setState(() {
                size = value;
              });
              print(size);
            },
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
            decoration: InputDecoration(
              labelText: 'BREED*',
            ),
            onChanged: (String value) {
              setState(() {
                breed = value;
              });
              print(breed);
            },
          ),
          SizedBox(
            height: 5,
          ),
          Text("GENDER*"),
          RadioButton(
            radio: 2,
            onTap: getSelectedGender,
          ),
          SizedBox(
            height: 10,
          ),
          nextButton(MediaQuery.of(context).size.width),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget nextButton(width) {
    return FlatButton(
      child: Container(
        width: width * .80,
        height: 45,
        color: Colors.grey.shade300,
        child: Center(
          child: Text(
            "Don",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      onPressed: () async {
        bool x=await _petProvider.addPet(name, specie, gender, size);
        if(x==true){
          Navigator.pop(context);

        }
      },
    );
  }

  getSelectedSpecie(int val) {
    if (val == 0) {
      specie = "1";
    }
    if (val == 1) {
      specie = "2";
    }
    if (val == 2) {
      specie = "3";
    }
    print(specie);
  }

  getSelectedGender(val) {
    if (val == 0) {
      gender = 1;
    }
    if (val == 1) {
      gender = 2;
    }
    print(gender);
  }
}
