import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  String title;
  Function onTap;
  bool value;

  CustomCheckBox({@required this.title, @required this.value, this.onTap});

  @override
  _CustomCheckBoxState createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
            value: widget.value,
            activeColor: Colors.green,
            onChanged: (newValue) {
              widget.onTap();
              setState(() {
                widget.value = newValue;
              });
            }),
        FlatButton(
            onPressed: () {
              widget.onTap();
              setState(() {
                widget.value = !widget.value;
              });
            },
            child: Text(
              widget.title,
              style: TextStyle(
                color: widget.value == true? Colors.green: Colors.black,
                fontSize: 16
              ),
            )),
      ],
    );
  }
}
