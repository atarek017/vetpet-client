import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/models/service_model.dart';
import 'package:vetwork_app/src/providers/authentiction.dart';
import 'package:vetwork_app/src/screens/home.dart';
import 'package:vetwork_app/src/widgets/cancel_chip.dart';
import 'package:vetwork_app/src/widgets/custom_service_chip.dart';
import '../widgets/background_container.dart';
import '../widgets/blueCircle.dart';
import '../fonts.dart';
import '../screens/request_information.dart';
import '../providers/preference_data_provider.dart';
import '../mixins/preferences_keys_mixin.dart';
import '../LocalizaionConstants.dart';

class ChooseSpecies extends StatefulWidget with PreferencesKeysMixin {
  @override
  State<StatefulWidget> createState() {
    return _ChooseSpeciesState();
  }
}

class _ChooseSpeciesState extends State<ChooseSpecies>
    with TickerProviderStateMixin, PreferencesKeysMixin {
  Color color1 = Colors.white;
  Color color2 = Colors.white;
  Color color3 = Colors.white;
  Color color4 = Colors.white;

  int serviceFlage = 0;
  int animationFlag = 0;
  String specie;
  String service;
  int sizeId; // null

  Animation<double> boxAnimation;
  Animation<double> highAnimation;
  AnimationController boxController;

  AnimationController fadeControllerHelth;
  AnimationController fadeControllerGrom;
  Animation<double> fadeAnimationHelth;
  Animation<double> fadeAnimationGrom;

  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  //chips
  List<CustomChip> servicesChips = [];
  List<ServiceModel> servicesLabelsHelth = [];
  List<ServiceModel> servicesLabelsGrom = [];

  int length = 0;

  initState() {
    super.initState();
    getservices();
    boxController =
        AnimationController(duration: Duration(milliseconds: 200), vsync: this);

    boxAnimation = Tween(begin: 100.0, end: 80.0)
        .animate(CurvedAnimation(parent: boxController, curve: Curves.easeIn));

    highAnimation = Tween(begin: 70.0, end: 50.0)
        .animate(CurvedAnimation(parent: boxController, curve: Curves.easeIn));

    fadeControllerHelth =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));

    fadeControllerGrom =
        AnimationController(vsync: this, duration: Duration(microseconds: 200));

    fadeAnimationHelth =
        Tween(begin: 0.0, end: 1.0).animate(fadeControllerHelth);
    fadeAnimationGrom = Tween(begin: 0.0, end: 1.0).animate(fadeControllerGrom);
  }

  getservices() async {
    List<ServiceModel> servicesLabels = [];

    PreferenceDataProvider preferenceDataProvider =
        new PreferenceDataProvider();
    servicesLabels = await preferenceDataProvider.getServices();

    ServiceModel service;
    for (service in servicesLabels) {
      if (service.svcTypId == 1) {
        servicesLabelsHelth.add(service);
      } else if (service.svcTypId == 2) {
        servicesLabelsGrom.add(service);
      }
    }
  }

  displaySnackBar(context, message) {
    SnackBar snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  startAnimation() {
    animationFlag = 1;
    boxController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: _scaffoldkey,
        body: Builder(
          builder: (context) {
            return Stack(
              children: <Widget>[
                BackgroundContainer(),
                Positioned(
                  top: _height * 0.8,
                  left: _width * 0.65,
                  child: BlueCircle(),
                ),

                //body
                topBodyColumn(),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                       Container(
                          width: _width *.6,
                      ),
                      InkWell(
                        child: CancelChip(),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              new MaterialPageRoute(
                                  builder: (BuildContext context) => Home()));
                        },
                      )
                    ],
                  ),
                ),
                animationFlag == 1 ? nextButton(_width, _height) : Text(""),
              ],
            );
          },
        ));
  }

  Widget topBodyColumn() {
    return ListView(
      padding: EdgeInsets.only(left: 20, right: 20),
      children: <Widget>[
        sizeBox(),
        animationFlag == 0
            ? FutureBuilder(
                future:
                    prefsDataProvider.getLabelFromKey(PREFS_LABEL_WELCOME_KEY),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      snapshot.data,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    );
                  return Container();
                },
              )
            : Text(""),
        SizedBox(
          height: 10,
        ),
        FutureBuilder(
          future: prefsDataProvider.getLabelFromKey(Label_CHOOSE_SPECIES),
          builder: (context, snapshot) {
            if (snapshot.hasData) return Text(snapshot.data, style: font2);
            return Container();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                setState(() {
                  specie = 'dog';
                  color1 = Colors.blue[50];
                  color2 = Colors.white;
                });
              },
              child: speciesBox(context, color1, PREFS_LABEL_PET_TYPE_1_KEY,
                  'assets/pets/dog.png'),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  setState(() {
                    specie = 'cat';
                    color2 = Colors.blue[50];
                    color1 = Colors.white;
                  });
                },
                child: speciesBox(context, color2, PREFS_LABEL_PET_TYPE_2_KEY,
                    'assets/pets/cat.png')),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder(
          future: prefsDataProvider.getLabelFromKey(Label_SERVICES_TITLE),
          builder: (context, snapshot) {
            if (snapshot.hasData) return Text(snapshot.data, style: font2);
            return Container();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (specie != null) {
                  setState(() {
                    serviceFlage = 0;
                    service = 'Healthcare';
                    color3 = Colors.blue[50];
                    color4 = Colors.white;
                    startAnimation();
                    fadeControllerHelth.forward();
                    fadeControllerGrom.reset();
                    PreferencesKeysMixin.services.clear();
                    setState(() {
                      length = PreferencesKeysMixin.services.length;
                    });
                  });
                }
              },
              child: speciesBox(context, color3, PREFS_LABEL_SVC_TYPE_1_KEY,
                  'assets/pets/health.png'),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
                onTap: () {
                  if (specie != null) {
                    setState(() {
                      serviceFlage = 1;
                      service = 'Grooming';
                      color4 = Colors.blue[50];
                      color3 = Colors.white;
                      startAnimation();
                      fadeControllerGrom.forward();
                      fadeControllerHelth.reset();
                      PreferencesKeysMixin.services.clear();
                      setState(() {
                        length = PreferencesKeysMixin.services.length;
                      });
                    });
                  }
                },
                child: speciesBox(context, color4, PREFS_LABEL_SVC_TYPE_2_KEY,
                    'assets/pets/grooming.png')),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Stack(
          children: <Widget>[
            serviceFlage == 1 ? grooming() : Container(),
            serviceFlage == 0
                ? FutureBuilder(
                    future: healthcare(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) return snapshot.data;
                      return Container();
                    },
                  )
                : Container(),
          ],
        )
      ],
    );
  }

  // sized box
  Widget sizeBox() {
    return AnimatedBuilder(
        animation: boxController,
        builder: (BuildContext context, Widget child) {
          return SizedBox(
            height: highAnimation.value,
          );
        });
  }

  // box
  Widget speciesBox(BuildContext context, Color color, String key, String img) {
    return AnimatedBuilder(
      animation: boxController,
      builder: (BuildContext context, Widget child) {
        return Container(
          height: boxAnimation.value,
          width: boxAnimation.value,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                )
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 50,
                height: 50,
              ),
              FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(key),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: color == Colors.blue[800]
                            ? Colors.white
                            : Colors.black,
                      ),
                    );
                  return Container();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<Widget> healthcare() async {
    return FadeTransition(
      opacity: fadeAnimationHelth,
      child: Container(
        height: 1250,
        padding: EdgeInsets.only(right: 20),
        child: Column(children: <Widget>[
          FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_CHOOSE_Services),
            builder: (context, snapshot) {
              if (snapshot.hasData) return Text(snapshot.data, style: font1);
              return Container();
            },
          ),
          SizedBox(
            height: 10,
          ),
          wrap(servicesLabelsHelth),
        ]),
      ),
    );
  }

  Widget grooming() {
    return FadeTransition(
      opacity: fadeAnimationGrom,
      child: Container(
        height: 500,
        child: Column(
          children: <Widget>[
//            FutureBuilder(
//              future:
//                  prefsDataProvider.getLabelFromKey(Label_WHAT_DOG_SIZE),
//              builder: (context, snapshot) {
//                if (snapshot.hasData)
//                  return Text(
//                    snapshot.data,
//                    textAlign: TextAlign.left,
//                    style: font1,
//                  );
//                return Container();
//              },
//            ),
//            SizedBox(
//              height: 5,
//            ),
//            FutureBuilder(
//              future: prefsDataProvider.getLabelFromKey(Label_DOG_SIZES),
//              builder: (context, snapshot) {
//                if (snapshot.hasData)
//                  return Text(
//                    snapshot.data,
//                    textAlign: TextAlign.left,
//                    style: TextStyle(color: Colors.grey),
//                  );
//                return Container();
//              },
//            ),
//            SizedBox(
//              height: 20,
//            ),
//            SizedBox(
//              height: 5,
//            ),
//            Text(
//              "Give an approximate estimation of your dog size to help us estimate the price.",
//              style: TextStyle(color: Colors.grey),
//            ),
//            SizedBox(
//              height: 20,
//            ),
//            dogSize(),
//            SizedBox(
//              height: 20,
//            ),
            wrap(servicesLabelsGrom),
          ],
        ),
      ),
    );
  }

  Widget wrap(List<ServiceModel> servicesLabels) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.spaceBetween,
      spacing: 4,
      children: true
          ? servicesChips = servicesLabels.map(
              (
                label,
              ) {
                return CustomChip(
                  index: label.id,
                  label: label.labelCode.toString(),
                  clicked: false,
                );
              },
            ).toList()
          : Container(),
    );
  }

  Widget dogSize() {
    return Row(
      children: <Widget>[
        InkWell(
          child: Container(
            height: 120,
            width: 70,
            color: sizeId == 1 ? Colors.brown : Colors.transparent,
            child: Image.asset(
              "assets/pics/small.png",
              width: 70,
              height: 120,
            ),
          ),
          onTap: () {
            setState(() {
              sizeId = 1;
              print("Sized: $sizeId");
            });
          },
        ),
        SizedBox(
          width: 15,
        ),
        InkWell(
          child: Container(
            height: 120,
            width: 70,
            color: sizeId == 2 ? Colors.brown : Colors.transparent,
            child: Image.asset(
              "assets/pics/mediam.png",
              width: 70,
              height: 120,
            ),
          ),
          onTap: () {
            setState(() {
              sizeId = 2;
              print("Sized: $sizeId");
            });
          },
        ),
        SizedBox(
          width: 15,
        ),
        InkWell(
          child: Container(
            width: 70,
            height: 120,
            color: sizeId == 3 ? Colors.brown : Colors.transparent,
            child: Image.asset(
              "assets/pics/large.png",
              width: 70,
              height: 120,
            ),
          ),
          onTap: () {
            setState(() {
              sizeId = 3;
              print("Sized: $sizeId");
            });
          },
        ),
      ],
    );
  }

  _saveToPrefrence() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String ser = '';
    for (var item in PreferencesKeysMixin.services) {
      ser += "$item-";
    }
    setState(() {
      length = PreferencesKeysMixin.services.length;
    });

    PreferencesKeysMixin.services.clear();
    await prefs.setString("specie", specie);
    await prefs.setString("service", service);
    await prefs.setString("services", ser);
    await prefs.setInt("petSizeId", sizeId);

    print("specie: $specie");
    print("service: $service");
  }

  Widget nextButton(double _width, double _height) {
    return Positioned(
      left: _width * 0.1,
      top: _height * 0.85,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: () {
            if (PreferencesKeysMixin.services.length > 0 || sizeId != null) {
              _saveToPrefrence();

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => RequestInformation()));
            } else {
              snackBar(_scaffoldkey, Label_CHOOSE_Services);
            }
          },
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_NEXT),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: PreferencesKeysMixin.services.length > 0 ||
                              sizeId != null
                          ? Colors.black
                          : Colors.grey,
                      fontSize: 18),
                );
              return Container();
            },
          ),
          color: PreferencesKeysMixin.services.length > 0 || sizeId != null
              ? Colors.grey.shade200
              : Colors.grey[300],
          minWidth: _width * 0.8,
        ),
      ),
    );
  }
}
