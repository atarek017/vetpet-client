import 'package:flutter/material.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';

class BackChip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();

    return Chip(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.keyboard_backspace,
            color: Colors.grey,
          ),

          FutureBuilder(
            future: prefsDataProvider.getLabelFromKey("back"),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(fontSize: 18),
                );
              return Container();
            },
          ),


        ],
      ),
      backgroundColor: Colors.white,
      //elevation: 4,
      labelPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.pets,
          color: Colors.blue,
        ),
      ),
    );
  }
}
