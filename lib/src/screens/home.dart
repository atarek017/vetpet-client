import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vetwork_app/src/models/active_request.dart';
import 'package:vetwork_app/src/models/address.dart';
import 'package:vetwork_app/src/models/pet.dart';
import 'package:vetwork_app/src/providers/verify_user.dart';
import 'package:vetwork_app/src/screens/status_route.dart';
import '../widgets/background_home.dart';
import 'chose_spcies.dart';
import '../fonts.dart';
import '../widgets/drawer.dart';
import '../providers/pet_provider.dart';
import '../providers/request_vist_provider.dart';
import '../providers/preference_data_provider.dart';
import '../mixins/preferences_keys_mixin.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../LocalizaionConstants.dart';
import '../providers/globals.dart' as globals;

class Home extends StatefulWidget {
  String token = "";

  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with PreferencesKeysMixin {
  List<Pet> pets = [];
  PetProvider petProvider = new PetProvider();
  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();

  List<ActiveRequests> activeRequests = [];
  RequestVistProvider requestVistProvider = new RequestVistProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int loading = 1;
  VerifyUser _user = VerifyUser();
  SharedPreferences prefs;
  String btnText ='';
  Map<String,String> headers = {HttpHeaders.authorizationHeader:globals.authToken,"Content-Type": "application/json"};


  @override
  void initState() {
    getpets();
    firebaseCloudMessaging_Listeners();
    super.initState();
  }

  getHeader()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }

  getpets() async {
    //pets = await petProvider.getPets();
    prefs = await SharedPreferences.getInstance();
    pets.add(Pet(
        3,
        3,
        3,
        await prefsDataProvider.getLabelFromKey(PREFS_LABEL_ANOTHER_KEY),
        "assets/pets/other.png"));
await getHeader();
    activeRequests = await requestVistProvider.activeRequests();

    loading = 0;

     btnText =await prefsDataProvider.getLabelFromKey(Label_CANCEL_CURRENT_VISIT);


    setState(() {});
  }

  Future<bool> cancelRequest() async {
    final String _baseAddress = 'https://capi-dev.vetwork.co/';
    String userId = prefs.getString("userID");
    var visitId = prefs.get("visitid");
    await getHeader();
    Map<String, dynamic> requestBody = {
      "userid": userId,
      "visitId": visitId,
    };

    http.Response response = await http.post(
      '$_baseAddress/visit/cancel',
      body: json.encode(requestBody),
      headers: headers,
    );

    var res = json.decode(response.body);

    if (res['success'] == true) {
      activeRequests = [];
      setState(() {});
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Background(),
        Scaffold(
          backgroundColor: Colors.transparent,
          drawer: contentDrawer(context, "home"),
          appBar: appBar(),
          body: ListView(
            padding: EdgeInsets.only(left: 10, right: 10),
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(Label_SAVED_PETS),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(snapshot.data, style: font2);
                  return Container();
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 70,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: pets.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AbsorbPointer(
                      absorbing: activeRequests.length == 0 ? false : true,
                      child: InkWell(
                        child: animalSlot(
                            pets[index].name,
                            pets[index].imgUrl == null
                                ? "assets/pics/vetpetlogologo.png"
                                : pets[index].imgUrl,
                            70,
                            130),
                        onTap: () {
                          if (index == (pets.length - 1) &&
                              activeRequests != null &&
                              activeRequests.length == 0) {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ChooseSpecies()));
                          } else {
                            _showDialog();
                          }
                        },
                      ),
                    ) ;
                  },
                ),
              ),
              SizedBox(
                height: 5,
              ),
               activeRequests.length > 0 ? FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(Label_ACTIVE_VISITS),
                builder: (context, snapshot) {
                  if (snapshot.hasData) return text(snapshot.data, font4);
                  return Container();
                },
              ) : Container(),
              SizedBox(
                height: 12,
              ),
              FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(Label_UPCOMING_VISITS),
                builder: (context, snapshot) {
                  if (snapshot.hasData) return text(snapshot.data, font2);
                  return Container();
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height * .2,
                child: loading == 0
                    ? ListView.builder(
                        itemCount: activeRequests.length,
                        itemBuilder: (BuildContext context, int index) {
                          prefs.setString(
                              "visitid", activeRequests[0].id.toString());
                          return InkWell(
                            child: comingVist(index),
                            onTap: () {
                              Navigator.of(context).push(new MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      StatusRoute()));
                            },
                          );
                        },
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.blue,
                        ),
                      ),
              ),
              Container(
                child: Offstage(
                    offstage: (activeRequests.length == 0),
                    child: RaisedButton(
                      onPressed: () async {
                        btnText = await prefsDataProvider
                            .getLabelFromKey(Label_PLEASE_WAIT);
                        String cancel = await prefsDataProvider
                            .getLabelFromKey(Label_CANCEL_CURRENT_VISIT);
                        setState(() {});
                        cancelRequest().then((value) {
                          if (!value) {
                            setState(() {
                              btnText = cancel;
                            });  
                          }
                        });
                      },
                      child: Text(btnText),
                    )),
                padding: EdgeInsets.fromLTRB(60, 0, 35, 0),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.grey.shade700),
      title: Image.asset(
        "assets/pets/applogo.png",height: 30,
      ),
    );
  }

  Widget animalSlot(
    text,
    image,
    double hight,
    double width,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: Container(
        height: hight,
        width: width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              image,
              width: 50,
              height: 50,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: font2,
            )
          ],
        ),
      ),
    );
  }

  Widget comingVist(int index) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.date_range),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            width: MediaQuery.of(context).size.width * .7,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: ListView(
              primary: false,
              padding: EdgeInsets.all(5),
              children: <Widget>[
                text(
                  activeRequests[index].date != null
                      ? activeRequests[index].date
                      : "",
                  font4,
                ),
                SizedBox(
                  height: 10,
                ),
                text(
                  activeRequests[index].address.line1,
                  font5,
                ),
                SizedBox(
                  height: 10,
                ),
                text(
                  activeRequests[index].provNo != null
                      ? activeRequests[index].provNo
                      : "",
                  font5,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget text(text, TextStyle style) {
    return Text(
      text,
      style: style,
    );
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.autoInitEnabled();
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("Vetpet token");
      print(token);
      _user.storePushToken(token);
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
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new   FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_NEW_VISITS),
            builder: (context, snapshot) {
              if (snapshot.hasData) return Text(snapshot.data);
              return Container();
            },
          ),
          content: new FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_ACTIVE_VISITS),
            builder: (context, snapshot) {
              if (snapshot.hasData) return Text(snapshot.data);
              return Container();
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(Label_OK),
                builder: (context, snapshot) {
                  if (snapshot.hasData) return Text(snapshot.data);
                  return Container();
                },
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
