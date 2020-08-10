import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vetwork_app/src/ServicePricesModel.dart';
import 'package:vetwork_app/src/screens/home.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/background_container.dart';
import '../widgets/blueCircle.dart';
import '../widgets/submit_button.dart';
import '../widgets/formated_text.dart';
import '../widgets/step_details.dart';
import '../widgets/back_chip.dart';
import '../providers/request_status.dart';
import '../providers/prices_provider.dart';
import '../providers/preference_data_provider.dart';
import '../mixins/preferences_keys_mixin.dart';
import 'add_pet.dart';
import '../LocalizaionConstants.dart';
import 'chose_spcies.dart';

class StatusRoute extends StatefulWidget {
  String token = "";

  @override
  _StatusRouteState createState() => _StatusRouteState();
}

class _StatusRouteState extends State<StatusRoute>
    with PreferencesKeysMixin, WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  AppLifecycleState _appLifecycleState;
  int _currentStep = 0;
  int _status = 0;
  bool _stepsCompleted = false;
  bool _petAdded = false;
  RequestStatus requestStatus = RequestStatus();
  PricesProvider pricesProvider = PricesProvider();
  List<int> services = [];
  List<double> prices = [];
  double totalPrice = 0;
  bool isLoading = true;
  String code = '';
  bool isError = false;
  PreferenceDataProvider preferenceProvider = PreferenceDataProvider();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int petSizeId;
  Timer _timer;
  String myservcies = null;
  String status_pending = '';
  String status_accepted = '';
  String status_onway = '';
  String status_onsite = '';
  String status_completed;
  ServicePricesModel model;
  double fees, extras;

  @override
  void initState() {
    super.initState();
    //Add Life Cycle Events.
    WidgetsBinding.instance.addObserver(this);
    getStatuse();
    firebaseCloudMessaging_Listeners();
    startTimer(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("Application Lice Cycle Changed $state");
    if ((state == AppLifecycleState.paused ||
            state == AppLifecycleState.inactive ) &&
        _timer != null) _timer.cancel();
    if (state == AppLifecycleState.resumed) startTimer(true);
    setState(() {
      _appLifecycleState = state;
    });
  }

  getServices() async {
    services = [];
    prices = [] ;
    totalPrice  = 0 ;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    myservcies = preferences.getString("services_");
    petSizeId = preferences.getInt('petSizeId');
    List<String> strService = [];
    if (petSizeId == null && myservcies != null) {
      strService = myservcies.split('-');
      for (String x in strService) {
        if (x.isNotEmpty && x != ' ' && x != '' && x != null) {
          services.add(int.parse(x));
        }
      }
      services.sort();
    } else {
      isLoading = false;
    }
    if (services != null && services.length > 0) {
      model = await pricesProvider.getPrices(services, scaffoldKey);

      if (model == null) {
        setState(() {
          isLoading = false;
        });
      } else {
        for (int i = 0; i < model.paras.prices.length; i++) {
          prices.add(model.paras.prices[i].price.toDouble());
        }
        setState(() {
          prices = prices;
          if (isExtra(model)) totalPrice += model.paras.extra.fees.toDouble();
          if (isRegular(model)) totalPrice += model.paras.regular.fees.toDouble();

          prices.forEach((double price) {
            totalPrice += price;
          });
          isLoading = false;
        });
      }
    } else {
      isLoading = false;
    }
  }

  getStatuse() async {
    status_pending =
        await preferenceProvider.getLabelFromKey(Label_STATUS_PENDING);
    status_accepted =
        await preferenceProvider.getLabelFromKey(Label_STATUS_ACCEPTED);
    status_onway = await preferenceProvider.getLabelFromKey(Label_STATUS_ONWAY);
    status_onsite =
        await preferenceProvider.getLabelFromKey(Label_STATUS_ONSITE);
    status_completed =
        await preferenceProvider.getLabelFromKey(Label_STATUS_COMPLETED);
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            BackgroundContainer(),
            Positioned(
              top: _height * 0.8,
              left: _width * 0.65,
              child: BlueCircle(),
            ),
            buildBodyListView(context),
//            FutureBuilder(future: getRequestStatue(),builder: (c,s){
//              if(s.connectionState == ConnectionState.waiting)
//                return Text("Loading");
//              else return buildBodyListView(context);
//            },)
          ],
        ));
  }

  ListView buildBodyListView(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 10),
            InkWell(
              child: BackChip(),
              onTap: () {
                if (_timer != null) _timer.cancel();
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => Home()));
              },
            ),
            SizedBox(width: 20),
          ],
        ),
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future: preferenceProvider.getLabelFromKey(Label_STATUS),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 10),
        _buildCompletedProcessContent(context),
        SizedBox(height: 10),
        buildStepper(context),

        //        _stepsCompleted
        //            ? _buildCompletedProcessContent(context)
        //            : _petBar(_petAdded, 'Baxter'),
      ],
    );
  }

  Widget _buildCompletedProcessContent(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(5),
          child: FutureBuilder(
            future: preferenceProvider.getLabelFromKey(Label_PROCESS_COMPLETE),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 5),
        isLoading
            ? Container(
                width: 300,
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : buildPricingRow(),
        SizedBox(height: 5),
        myservcies == null
            ? Container(
                height: 0,
              )
            : Row(
                children: <Widget>[
                  SizedBox(width: 20),
                  Expanded(
                    child: FutureBuilder(
                      future: preferenceProvider.getLabelFromKey(Label_TOTAL),
                      builder: (context, snapshot) {
                        if (snapshot.hasData)
                          return FormattedText(
                            snapshot.data,
                            bold: true,
                          );
                        return Container();
                      },
                    ),
                  ),
                  FormattedText('$totalPrice EGP',
                      color: Colors.black, bold: true),
                  SizedBox(width: 30),
                ],
              ),
        SizedBox(height: 10),
        petSizeId == 1
            ? Center(
                child: Container(
                    width: 80,
                    height: 130,
                    child: Image.asset('assets/pics/small.png')))
            : Container(),
        petSizeId == 2
            ? Center(
                child: Container(
                    width: 80,
                    height: 130,
                    child: Image.asset('assets/pics/mediam.png')))
            : Container(),
        petSizeId == 3
            ? Center(
                child: Container(
                    width: 80,
                    height: 130,
                    child: Image.asset('assets/pics/large.png')))
            : Container(),
        //        Row(
        //          mainAxisAlignment: MainAxisAlignment.center,
        //          children: <Widget>[
        //            buildSubmitButton(MediaQuery.of(context).size.width, 60),
        //          ],
        //        ),
        //SizedBox(height: 30),
        //        Row(
        //          mainAxisAlignment: MainAxisAlignment.center,
        //          children: <Widget>[
        //            FlatButton(
        //                onPressed: () {},
        //                child: Text(
        //                  'Decline',
        //                  style: TextStyle(
        //                    fontSize: 20,
        //                  ),
        //                ))
        //          ],
        //        ),
        //        SizedBox(height: 80),
      ],
    );
  }

  buildPricingRow() {
    var row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(width: 20),
        Expanded(
          child: Column(
            children: services
                .map((ser) => Column(
                      children: <Widget>[
                        FutureBuilder(
                            future: preferenceProvider.getServiceLabel(ser),
                            builder: (context, snapShot) {
                              if (snapShot.hasData)
                                return FormattedText(snapShot.data);
                              return Container(height: 30);
                            }),
                        SizedBox(height: 10),
                      ],
                    ))
                .toList(),
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: prices
              .map((ser) => Column(
                    children: <Widget>[
                      FormattedText('$ser EGP',
                          color: Colors.black, bold: true),
                      SizedBox(height: 10),
                    ],
                  ))
              .toList(),
        ),
        SizedBox(width: 30),
      ],
    );


    var row2  =   Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: isExtra(model)
              ? FutureBuilder(
            future: preferenceProvider.getLabelFromKey(Label_EXTRA),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return FormattedText(snapshot.data, bold: true);
              return Container();
            },
          )
              : Text(""),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: isExtra(model)
              ? FormattedText(
            '${model.paras.extra.fees.toString()} EGP',
            bold: true,
          )
              : Text(""),
        ),
      ],
    );

    var row3 = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: isRegular(model)
              ? FutureBuilder(
            future: preferenceProvider.getLabelFromKey(Label_REGULAR),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return FormattedText(
                  snapshot.data,
                  bold: true,
                );
              return Container();
            },
          )
              : Text(""),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
          child: isRegular(model)
              ? FormattedText(
            '${model.paras.regular.fees.toString()} EGP',
            bold: true,
          )
              : Text(""),
        ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        row,
        row2,
        row3
      ],
    );
  }

  Widget _petBar(bool isAdded, String name) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddPet()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: isAdded ? Colors.green : Colors.black54,
            child: IconButton(
              icon: Icon(
                isAdded ? Icons.check : Icons.add,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          SizedBox(width: 10),
          Text(
            isAdded ? '$name has been added' : 'Add pet for future use',
            style: TextStyle(fontSize: 16),
          )
        ],
      ),
    );
  }

  Stepper buildStepper(BuildContext context) => Stepper(
        steps: _steps(_currentStep),
        currentStep: _currentStep,
        physics: ClampingScrollPhysics(),
        controlsBuilder: (BuildContext context,
            {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
          return Container();
        },
      );

  // TODO show step titles from labels
  List<Step> _steps(int currentItem) {
    List<Step> mySteps = [
      Step(
        title: buildStepShape(1, currentItem, status_pending, context),
        content: Container(),
        isActive: _currentStep == 0,
      ),
      Step(
          title: buildStepShape(2, currentItem, status_accepted, context),
          content: Container(),
          isActive: _currentStep == 1),
      Step(
          title: _stepsCompleted
              ? stepTitle(status_onway)
              : buildStepShape(3, currentItem, status_onway, context),
          content: Container(),
          isActive: _currentStep == 2),
      Step(
          title: _stepsCompleted
              ? stepTitle(status_onsite)
              : buildStepShape(4, currentItem, status_onsite, context),
          content: Container(),
          isActive: _currentStep == 3),
      Step(
          title: _stepsCompleted
              ? stepTitle(status_completed)
              : buildStepShape(5, currentItem, status_completed, context),
          content: Container(),
          isActive: _currentStep == 4)
    ];
    return mySteps;
  }

  Widget buildStepShape(
      int stepIndex, int currentItem, String title, BuildContext context) {
    if ((currentItem + 1) >= stepIndex) {
      return stepTitle(title, color: Colors.green, isComplete: true);
    } else {
      return stepTitle(title);
    }
  }

  Widget stepTitle(String name,
      {Color color = Colors.grey, bool isComplete = false}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(
            name ?? 'unknown',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          isComplete
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                )
              : Container(),
        ],
      ),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
    );
  }

  void firebaseCloudMessaging_Listeners() {
    _firebaseMessaging.setAutoInitEnabled(true);
    _firebaseMessaging.autoInitEnabled();
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("Vetpet token");
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
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  isExtra(ServicePricesModel model) {
    if (model != null) {
      if (model.paras.extra != null)
        return true;
      else
        return false;
    } else
      return false;
  }

  isRegular(ServicePricesModel model) {
    if (model != null) {
      if (model.paras.regular != null)
        return true;
      else
        return false;
    } else
      return false;
  }

  startTimer(bool timerEnabled) {
      if (_timer != null) _timer.cancel();
      getRequestStatus().then((value) {
        if (value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ChooseSpecies()));
        } else if (services == null || services.length == 0){
          getServices();
        }
      }).whenComplete((){
        if (timerEnabled) {
          Timer.periodic(Duration(seconds: 2), (timer) {
            _timer = timer;
            getRequestStatus().then((value) {
              if (value) {
                _timer.cancel();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => ChooseSpecies()));
              } else if (services == null || services.length == 0) {
                getServices();
              }
            });
          });
        }
      });
    }

  Future<bool> getRequestStatus() async {
    int result = await requestStatus.getRequestStatus();
    if (result == 5 || result == 6 || result == 7) {
      return true;
    } else {
      setState(() {
        if (result <= 5) {
          _currentStep = result - 1;
        } else if (result == 6) {
          _currentStep = 0;
          _stepsCompleted = false;
          //snackBarComposer(scaffoldKey, 'Request Canceled');
        } else {
          _currentStep = 0;
          code = result.toString();
          isError = true;
          print('status error $code');
          snackBar(scaffoldKey, code);
        }
      });
      return false;
    }
  }
}
