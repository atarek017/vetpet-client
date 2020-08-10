import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/services.dart';

class DevSettings extends StatefulWidget {
  String token="";

  DevSettingState createState() => DevSettingState();
}

class DevSettingState extends State<DevSettings> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();



  @override
  void initState() {
    super.initState();
   firebaseCloudMessaging_Listeners();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildListLivew(),appBar: AppBar(title: Text("Dev Settings"),),);
  }
  
  
  Widget buildListLivew(){
    return ListView(children: <Widget>[
      Card(child: ListTile(title: Text("App Token"),subtitle: GestureDetector(child: CustomToolTip(text:widget.token.toString()),onTap: (){},),),)
    ],);
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.autoInitEnabled();
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token){
      print("token");
      print(token);
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

class CustomToolTip extends StatelessWidget {

  String text;

  CustomToolTip({this.text});

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Tooltip(preferBelow: false,
          message: "Copy", child: new Text(text)),
      onTap: () {
        Clipboard.setData(new ClipboardData(text: text));
      },
    );
  }
}