import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/providers/verify_user.dart';

import '../providers/authentiction.dart';
import '../providers/active_requests.dart';
import '../screens/chose_spcies.dart';
import 'home.dart';
import 'status_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SplashScreen extends StatefulWidget {
  String token="";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Authentication authentication = Authentication();
  bool shouldSelectLanguage = false;
  bool shouldSelectLabels = false;
  bool isLoading = true;
  VerifyUser _user = VerifyUser();
  @override
  void initState() {
    super.initState();
    print("App Start");
    firebaseCloudMessaging_Listeners();
    authentication.authenticate().then((value){
    authenticationLogic();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: shouldSelectLanguage
                  ? ListView.builder(
                      itemCount: authentication.languages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(authentication.languages[index].name),
                          onTap: () async {
                            await authentication.updateLangVersion(
                                await authentication.getApiLanguageVersion());
                            await authentication.storeLanguage(
                                authentication.languages[index].id);
                            await authentication.fetchLabelsData();
                            await authentication.updateLblVersion(
                                await authentication.getApiLabelsVersion());
                            authenticationLogic();
                          },
                        );
                      })
                  : Container(),
            ),
    );
  }

  authenticationLogic() async {
    bool languageResult = await authentication.checkLngVersion();
    if (languageResult) {
      setState(() {
        isLoading = false;
        shouldSelectLanguage = true;
      });
    }


    bool labelsResult = await authentication.checkLblVersion();
   int lngVersion = await authentication.getCurrentLangVersion();
    if (labelsResult && lngVersion != 0) {
      setState(() async{
        await authentication.fetchLabelsData();
        await authentication.updateLblVersion(
            await authentication.getApiLabelsVersion());
        authenticationLogic();
      });
    }

    //Force Update Language
    await authentication.fetchLabelsData();
    await authentication.updateLblVersion(
    await authentication.getApiLabelsVersion());

    // if there is no change in labels and language navigate
    if (!languageResult && !labelsResult) navigate(context);
  }


  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.autoInitEnabled();
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print("Vetpet token");
      print(token);
      _user.storePushToken(token);
      setState(() {
        widget.token = token;

      });
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }
  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true)
    );
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings)
    {
      print("Settings registered: $settings");
    });
  }
}

void navigate(BuildContext context) async {
   print('Splash Started');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String id = (prefs.getString('userID') ?? '');
  if (id != '') {
    // check visits
    ActiveRequest().checkHasActiveRequests(id).then((bool result) {
      if (result!=null && result) {
        // user have active requests navigate to requests screen
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StatusRoute()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ChooseSpecies()));
      }
    });
  } else {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ChooseSpecies()));
  }
}

