import 'dart:async';

import 'package:flutter/material.dart';
import '../providers/authentiction.dart';
import '../mixins/preferences_keys_mixin.dart';

class ChangeLanguage extends StatefulWidget {
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage>
    with PreferencesKeysMixin {
  Authentication authentication = Authentication();
  bool isLoading = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initialState();
  }

  initialState() async {
    int version = await authentication.getCurrentLangVersion();
    await authentication.getLanguages(version);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Select app language'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: authentication.languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(authentication.languages[index].name),
                  onTap: () async {
                    snackBarComposer(scaffoldKey, 'Language changed');
                    await authentication
                        .storeLanguage(authentication.languages[index].id);
                    await authentication.updateLblVersion(
                        await authentication.getApiLabelsVersion());
                    await authentication.fetchLabelsData();
                  },
                );
              }),
    );
  }
}
