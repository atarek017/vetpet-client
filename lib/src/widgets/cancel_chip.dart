import 'package:flutter/material.dart';
import 'package:vetwork_app/src/mixins/preferences_keys_mixin.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';

class CancelChip extends StatelessWidget with PreferencesKeysMixin {
  @override
  Widget build(BuildContext context) {
    PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();

    return Chip(
      label: FutureBuilder(
        future: prefsDataProvider.getLabelFromKey(PREFS_LABEL_CANCEL_KEY),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Text(
              snapshot.data,
              style: TextStyle(fontSize: 18,color: Colors.grey[700]),
            );
          return Container();
        },
      ),
      backgroundColor: Colors.white,
      //elevation: 4,
      labelPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 7),
      avatar: CircleAvatar(
        backgroundColor: Colors.white,
        child: Icon(
          Icons.close,
          color: Colors.grey,
        ),
      ),
    );
  }
}
