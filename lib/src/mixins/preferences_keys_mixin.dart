import 'package:flutter/material.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';

class PreferencesKeysMixin {
  final String PREFS_RESPONSE_BODY_KEY = 'response_body';
  final String PREFS_VERSION_KEY = 'version';
  final String PREFS_LABEL_ANOTHER_KEY = 'another';
  final String PREFS_LABEL_BIG_SIZE_1_KEY = 'bigsize_1';
  final String PREFS_LABEL_CANCEL_KEY = 'cancel';
  final String PREFS_LABEL_CHECKUP_KEY = 'checkup';
  final String PREFS_LABEL_DEWORMING_KEY = 'deworming';
  final String PREFS_LABEL_EVACUATION_KEY = 'evacuation';
  final String PREFS_LABEL_HELP_KEY = 'help';
  final String PREFS_LABEL_HOME_KEY = 'home';
  final String PREFS_LABEL_MSG_111_KEY = 'msg_111';
  final String PREFS_LABEL_MSG_900_KEY = 'msg_900';
  final String PREFS_LABEL_MSG_910_KEY = 'msg_910';
  final String PREFS_LABEL_MSG_911_KEY = 'msg_911';
  final String PREFS_LABEL_MSG_999_KEY = 'msg_999';
  final String PREFS_LABEL_OFFER_KEY = 'offer';
  final String PREFS_LABEL_PET_TYPE_1_KEY = 'pettype_1';
  final String PREFS_LABEL_PET_TYPE_2_KEY = 'pettype_2';
  final String PREFS_LABEL_SVC_TYPE_1_KEY = 'svctype_1';
  final String PREFS_LABEL_SVC_TYPE_2_KEY = 'svctype_2';
  final String PREFS_LABEL_USERNAME_KEY = 'username';
  final String PREFS_LABEL_VACCINE_KEY = 'vaccine';
  final String PREFS_LABEL_WELCOME_KEY = 'welcome';
  final String PREFS_LABEL_XRAY_KEY = 'xray';

  static List<int> services = [];

  snackBar(scaffoldKey, labelKey) {
    PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();
    final snack = new SnackBar(
      content: FutureBuilder(
        future: prefsDataProvider.getLabelFromKey(labelKey),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(
              snapshot.data.toString(),
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            );
          } else {
            return Container();
          }
        },
      ),
      backgroundColor: Colors.blue[800],
    );
    scaffoldKey.currentState.showSnackBar(snack);
  }

  String getLabelKey(labelCode) {
    if (labelCode == '111') {
      return PREFS_LABEL_MSG_111_KEY;
    }
    if (labelCode == '900') {
      return PREFS_LABEL_MSG_900_KEY;
    }
    if (labelCode == '910') {
      return PREFS_LABEL_MSG_910_KEY;
    }
    if (labelCode == '911') {
      return PREFS_LABEL_MSG_911_KEY;
    }
    if (labelCode == '999') {
      return PREFS_LABEL_MSG_999_KEY;
    } else {
      return labelCode;
    }
  }

  snackBarComposer(GlobalKey<ScaffoldState> scaffoldKey, message) {
    scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }
}
