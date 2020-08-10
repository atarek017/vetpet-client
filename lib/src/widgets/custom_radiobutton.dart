import 'package:flutter/material.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';

class CustomRadio extends StatefulWidget {
  final List<RadioModel> models;

  CustomRadio(this.models);

  @override
  createState() {
    return new CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> sampleData = new List<RadioModel>();

  @override
  void initState() {
    super.initState();
    widget.models.forEach((RadioModel model) {
      sampleData.add(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: sampleData.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          //highlightColor: Colors.red,
          splashColor: Colors.blueAccent,
          onTap: () {
            setState(() {
              sampleData.forEach((element) => element.isSelected = false);
              sampleData[index].isSelected = true;
              sampleData[index].onTap();
            });
          },
          child: new RadioItem(sampleData[index]),
        );
      },
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;

  RadioItem(this._item);

  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0),
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
            margin: EdgeInsets.only(left: 0.0),
            child: FlatButton(
              child: FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(_item.text),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              _item.isSelected ? Colors.green : Colors.black),
                    );
                  return Container();
                },
              ),
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
