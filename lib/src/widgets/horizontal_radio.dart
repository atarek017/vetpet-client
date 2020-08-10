import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/pet_model.dart';
import '../enums/data_type.dart';
import '../enums/gender.dart';

class HorizontalRadio extends StatefulWidget {
  final List<RadioModel> models;
  final DataType type;

  HorizontalRadio(this.type, this.models);

  @override
  createState() {
    return new HorizontalRadioState();
  }
}

class HorizontalRadioState extends State<HorizontalRadio> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
    widget.models.forEach((RadioModel radioModel) {
      sampleData.add(radioModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PetModel>(
        builder: (context, child, PetModel model) {
      return ListView.builder(
        itemCount: sampleData.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            //highlightColor: Colors.red,
            splashColor: Colors.blueAccent,
            onTap: () {
              setState(() {
                sampleData.forEach((element) => element.isSelected = false);
                sampleData[index].isSelected = true;
                if (widget.type == DataType.Species) {
                  model.setSpecies(getValue(sampleData[index]));
                } else if (widget.type == DataType.Gender) {
                  model.setGender(getValue(sampleData[index]));
                } else if (widget.type == DataType.Neutered) {
                  model.setNeutered(getValue(sampleData[index]));
                } else if (widget.type == DataType.Insured) {
                  model.setInsured(getValue(sampleData[index]));
                }
              });
            },
            child: new RadioItem(sampleData[index]),
          );
        },
      );
    });
  }

  dynamic getValue(RadioModel item) {
    var value;
    switch (widget.type) {
      case DataType.Species:
        value = item.text;
        break;
      case DataType.Gender:
        value = item.text == 'Male' ? 1 : 2;
        break;
      case DataType.Neutered:
        value = item.text == 'Yes' ? true : false;
        break;
      case DataType.Insured:
        value = item.text == 'Yes' ? true : false;
        break;
    }
    return value;
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            height: 30.0,
            width: 40.0,
            child: Center(
              child: _item.isSelected
                  ? Container(
                      width: 25,
                      height: 25,
                      child: Center(
                          child: Icon(
                        Icons.check,
                        color: Colors.white,
                      )),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.green, width: 2),
                          borderRadius: BorderRadius.circular(4)),
                    )
                  : Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 2),
                          borderRadius: BorderRadius.circular(4)),
                    ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: Text(
              _item.text,
              style: TextStyle(
                  fontSize: 16,
                  color: _item.isSelected ? Colors.green : Colors.black),
            ),
          )
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;
  final Function onTap;

  RadioModel(this.isSelected, this.text, {this.onTap});
}

///
