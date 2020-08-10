import 'package:flutter/material.dart';
import 'package:vetwork_app/src/mixins/preferences_keys_mixin.dart';

class CustomChip extends StatefulWidget with PreferencesKeysMixin {
  int index;
  bool clicked;
  String label;

  CustomChip({this.index, this.label, this.clicked});

  @override
  State<StatefulWidget> createState() {
    return CustomChipState();
  }
}

class CustomChipState extends State<CustomChip> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      margin: EdgeInsets.all(0.0),
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Chip(
        backgroundColor:
            widget.clicked ? Colors.blue[900] : Colors.grey.shade200,
        label: InkWell(
          child: Text(
            widget.label,
            style: TextStyle(
                color: widget.clicked ? Colors.white : Colors.grey[700],
                fontSize: 16),
          ),
          onTap: () async {
            setState(() {
              widget.clicked = !widget.clicked;
              if (widget.clicked) {
                  PreferencesKeysMixin.services.add(widget.index);
                print(PreferencesKeysMixin.services.toString());
              } else if (!widget.clicked) {
                PreferencesKeysMixin.services.remove(widget.index);
                print(PreferencesKeysMixin.services.toString());
              }
            });
          },
        ),
      ),
    );
  }
}
