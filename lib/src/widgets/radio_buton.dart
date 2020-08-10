import 'package:flutter/material.dart';

class RadioButton extends StatefulWidget {
  int radio;
  Function onTap;
  RadioButton({this.radio, this.onTap});
  @override
  State<StatefulWidget> createState() {
    return RadioButtonState();
  }
}

class RadioButtonState extends State<RadioButton> {
  int selected;
  int selected2;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: widget.radio == 1 ? makeRadio1() : makeRadio2(),
      ),
    );
  }

  List<Widget> makeRadio1() {
    List<Widget> list = new List<Widget>();

    list.add(Row(
      children: <Widget>[
        Radio(
          activeColor: Colors.orange,
          value: 0,
          groupValue: selected,
          onChanged: (int value) {
            setState(() {
              selected = value;
              widget.onTap(value);
            });
          },
        ),
        Text('dog'),
      ],
    ));

    list.add(Row(
      children: <Widget>[
        Radio(
          activeColor: Colors.orange,
          value: 1,
          groupValue: selected,
          onChanged: (int value) {
            setState(() {
              selected = value;
              widget.onTap(value);
            });
          },
        ),
        Text("Cat"),
      ],
    ));

    list.add(Row(
      children: <Widget>[
        Radio(
          activeColor: Colors.orange,
          value: 2,
          groupValue: selected,
          onChanged: (int value) {
            setState(() {
              selected = value;
              widget.onTap(value);
            });
          },
        ),
        Text("other"),
      ],
    ));

    return list;
  }

  List<Widget> makeRadio2() {
    List<Widget> list = new List<Widget>();

    list.add(Row(
      children: <Widget>[
        Radio(
          activeColor: Colors.orange,
          value: 0,
          groupValue: selected2,
          onChanged: (int value) {
            setState(() {
              selected2 = value;
              widget.onTap(value);
            });
          },
        ),
        Text('Mail'),
      ],
    ));

    list.add(Row(
      children: <Widget>[
        Radio(
          activeColor: Colors.orange,
          value: 1,
          groupValue: selected2,
          onChanged: (int value) {
            setState(() {
              selected2 = value;
              widget.onTap(value);
            });
          },
        ),
        Text("Female"),
      ],
    ));

    return list;
  }


}
