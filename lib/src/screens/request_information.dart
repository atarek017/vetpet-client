import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:vetwork_app/src/models/active_request.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';
import 'package:vetwork_app/src/providers/request_vist_provider.dart';
import 'package:vetwork_app/src/screens/home.dart';
import '../widgets/background_container.dart';
import '../widgets/blueCircle.dart';
import '../widgets/cancel_chip.dart';
import '../widgets/back_chip.dart';
import '../screens/payment_confirmation.dart';
import '../providers/verify_user.dart';
import '../providers/address_provider.dart';
import '../widgets/custom_radiobutton.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';

import 'package:flutter/services.dart';
import '../mixins/preferences_keys_mixin.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../widgets/map_dialog.dart';
import '../models/address.dart';
import '../LocalizaionConstants.dart';

const kGoogleApiKey = "AIzaSyAWdJUdZD75aDBqMMAT3RITwbjqMAs5WVw";
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class RequestInformation extends StatefulWidget {
  @override
  _RequestInformationState createState() => _RequestInformationState();
}

class _RequestInformationState extends State<RequestInformation>
    with PreferencesKeysMixin {
  bool _checkBoxValue = false;
  VerifyUser _user = VerifyUser();
  String phoneNumber = '';
  String userName = '';
  String verificationCode;
  Location location = Location(0, 0);
  Map<String, double> currentLocation = Map();
  String error;
  LatLng _center = LatLng(30.044281, 31.340002);
  DateTime schedulingDate = DateTime.now();
  AddressProvider _addressProvider = new AddressProvider();
  String dateSaved = '';
  bool dateCanceled = true;
  int locationSaved = -1;
  bool isVeryfied = false;
  bool isVerifying = false;
  bool isConfirming = false;
  bool isScheduled = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  SharedPreferences prefs;
  bool isPriority = false;

  // CLASS MEMBER, MAP OF MARKS

  List<RadioModel> models = [];
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  List<Address> address = [];
  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();
  RequestVistProvider requestVistProvider = new RequestVistProvider();
  List<ActiveRequests> activeRequests = [];

  String nameInput;
  String nameHintInput;
  String nameValidation;

  String mobileInput;
  String mobileHintInput;
  String mobileValidation;
  String userId = null;

  @override
  void initState() {
    super.initState();

    currentLocation['latitude'] = 30.044281;
    currentLocation['longitude'] = 31.340002;

    initialState();
    //getUserCurrentLocation();

    setState(() {});
  }

  initialState() async {
    nameInput = await prefsDataProvider.getLabelFromKey(Label_NAME);
    nameHintInput = await prefsDataProvider.getLabelFromKey(Label_NAME_HINT);
    nameValidation = await prefsDataProvider.getLabelFromKey(Label_VALIDATION);

    mobileInput = await prefsDataProvider.getLabelFromKey(Label_MOBILE);
    mobileHintInput =
        await prefsDataProvider.getLabelFromKey(Label_MOBILE_HINT);
    mobileValidation =
        await prefsDataProvider.getLabelFromKey(Label_MOBILE_VALIDATION);

    prefs = await SharedPreferences.getInstance();
    locationSaved = await prefs.getInt('adressid') ?? -1;
    userId = await prefs.getString('userID') ?? '';
    if (userId != null && userId != '') {
      userName = await prefs.getString('userName');
      phoneNumber = await prefs.getString('phone');
      setState(() {
        nameController.text = userName;
        phoneController.text = phoneNumber;
        isVeryfied = true;
//        getLocation();
      });
    }
  }

  getLocation() async {
    address = await _addressProvider.getAddress();

    if (address.length > 0) {
      locationSaved = 3;
    }
    setState(() {});
  }

  initRadioModels() {
    models.add(RadioModel(false, Label_SCHEDULE_VISIT, onTap: () {
      showDatePickerBottomSheet(context);
    }));
//    models.add(RadioModel(false, Label_PRIORITY_SERVICE, onTap: () async {
//      schedulingDate = DateTime.now().add(new Duration(minutes: 30));
//      String date = schedulingDate.toIso8601String();
//      print("Date: $date");
//      SharedPreferences shared = await SharedPreferences.getInstance();
//      shared.setString('date', date);
//      print("VetPet Request Service:$date");
//      setState(() {
//        dateSaved = date;
//        isScheduled = false;
//        isPriority = true;
//      });
//    }));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;
    if (models.length <= 2 && models.isEmpty) {
      initRadioModels();
    }
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
          buildBodyColumn(_checkBoxValue, context),
          buildNextButton(_width, _height, isVeryfied),
        ],
      ),
    );
  }

  Widget buildBodyColumn(bool checkBoxValue, context) {
    return ListView(
      children: <Widget>[
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              InkWell(
                child: BackChip(),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              InkWell(
                child: CancelChip(),
                onTap: () {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (BuildContext context) => Home()));
                },
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_REQUEST_INFO),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future:
                prefsDataProvider.getLabelFromKey(Label_FINISH_YOUR_REQUEST),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_NAME),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return TextField(
                  maxLength: 50,
                  controller: nameController,
                  decoration: InputDecoration(
                    errorText:
                        nameController.text.isEmpty ? nameValidation : null,
                    enabled: !isVeryfied,
                    labelText: nameInput,
                    hintText: nameHintInput,
                  ),
                  onChanged: (String value) {
                    setState(() {
                      userName = value;
                    });
                  },
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_MOBILE),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return TextField(
                  maxLength: 11,
                  controller: phoneController,
                  decoration: InputDecoration(
                    errorText:
                        nameController.text.isEmpty ? mobileValidation : null,
                    enabled: !isVeryfied,
                    labelText: mobileInput,
                    hintText: mobileHintInput,
                    prefixText: '+20',
                    prefixStyle: TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.check_circle,
                        color: isVeryfied ? Colors.green : Colors.grey,
                      ),
                      onPressed: isVerifying
                          ? () {
                              print('code on it\'s way wait a moment');
                            }
                          : () async {
                              if (nameController.text.isEmpty) {
                                snackBar(scaffoldKey, nameValidation);
                                return;
                              } else {
                                prefs.setString('userName', userName);
                              }
                              if (phoneController.text.isEmpty) {
                                snackBar(scaffoldKey, mobileValidation);
                                return;
                              }

                              setState(() {
                                isVerifying = true;
                              });
                              String resultCode =
                                  await _user.verifyUser(phoneNumber);
                              print(resultCode.runtimeType);
                              setState(() {
                                isVerifying = false;
                              });
                              if (resultCode == '111') {
                                showVerificationDialog(context);
                              } else {
                                snackBar(scaffoldKey, resultCode);
                              }
                            },
                    ),
                    suffix: GestureDetector(
                      onTap: isVerifying
                          ? () {
                              print('code on it\'s way wait a moment');
                            }
                          : () async {
                              setState(() {
                                isVerifying = true;
                              });
                              String resultCode =
                                  await _user.verifyUser(phoneNumber);
                              print(resultCode.runtimeType);
                              setState(() {
                                isVerifying = false;
                              });
                              if (resultCode == '111') {
                                showVerificationDialog(context);
                              } else {
                                snackBar(scaffoldKey, resultCode);
                              }
                            },
                      child: isVeryfied
                          ? FutureBuilder(
                              future: prefsDataProvider
                                  .getLabelFromKey(Label_VERIFIED),
                              builder: (context, snapshot) {
                                if (snapshot.hasData)
                                  return Text(
                                    snapshot.data,
                                    style: TextStyle(color: Colors.green),
                                  );
                                return Container();
                              },
                            )
                          : FutureBuilder(
                              future: prefsDataProvider
                                  .getLabelFromKey(Label_VERIFY),
                              builder: (context, snapshot) {
                                if (snapshot.hasData)
                                  return Text(
                                    snapshot.data,
                                  );
                                return Container();
                              },
                            ),
                    ),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      phoneNumber = value;
                    });
                    print(phoneNumber);
                  },
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            height: 60,
            child: CustomRadio(models)),
        SizedBox(height: 10),
        isScheduled && !dateCanceled
            ? Column(
                children: <Widget>[
                  buildDateRow(),
                  SizedBox(height: 20),
                ],
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_LOCATION),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                );
              return Container();
            },
          ),
        ),
        SizedBox(height: 10),
        buildSetLocationRow(context, isVeryfied),
        SizedBox(
          height: 200,
        )
      ],
    );
  }

  // todo run!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  Widget buildSetLocationRow(context, bool state) {
    MapDialog mapDialog = new MapDialog(scaffoldKey);
    return
//    locationSaved != -1
//        ? buildCompleteLocationRow()
        GestureDetector(
      onTap: () {
        scaffoldKey.currentState.showBottomSheet((BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 40,
                alignment: AlignmentDirectional.centerStart,
                width: MediaQuery.of(context).size.width,
                color: Colors.green.withOpacity(0.3),
                child: FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: FutureBuilder(
                    future: prefsDataProvider.getLabelFromKey(Label_CANCEL),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return Text(
                          snapshot.data,
                          style: TextStyle(color: Colors.black54, fontSize: 20),
                        );
                      return Container();
                    },
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  //Navigator.of(context).pop();
                  print('pick your location');
                  if (state) {
                    mapDialog.displayMapDialog(context).then((_) {
                      // this is called after closing the dialog
                      buildOldLocationsList();
                      setState(() {});
                    });
                  } else {
                    snackBarComposer(scaffoldKey, Label_VERIFY_MOBILE);
                  }
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.blue,
                        size: 25,
                      ),
                      SizedBox(width: 20),
                      FutureBuilder(
                        future: prefsDataProvider
                            .getLabelFromKey(Label_ADD_NEW_ADDRESS),
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Text(snapshot.data,
                                style: TextStyle(fontSize: 16));
                          return Container();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2),
              Divider(),
              SizedBox(height: 2),
              buildOldLocationsList(),
            ],
          );
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 20),
          CircleAvatar(
            backgroundColor: locationSaved == 3 ? Colors.green : Colors.black,
            child: Icon(
              Icons.location_on,
              color: Colors.white,
              size: 20,
            ),
          ),
          Container(
            width: 250,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: FutureBuilder(
                future: getCurrentSavedAddress(),
                builder: (c, data) {
                  return locationSaved == 3
                      ? FutureBuilder(
                          future: prefsDataProvider
                              .getLabelFromKey(Label_YOUR_LOCATION),
                          builder: (context, snapshot) {
                            if (snapshot.hasData)
                              return Text(
                                '${snapshot.data} \n ${data.data}',
                                style: TextStyle(fontSize: 16),
                              );
                            return Container();
                          },
                        )
                      : FutureBuilder(
                          future: prefsDataProvider
                              .getLabelFromKey(Label_SET_YOUR_LOCATION),
                          builder: (context, snapshot) {
                            if (snapshot.hasData)
                              return Text(
                                snapshot.data,
                                style: TextStyle(fontSize: 18),
                              );
                            return Container();
                          },
                        );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOldLocationsList() {
    return FutureBuilder(
        future: _addressProvider.getAddress(),
        builder: (BuildContext context, AsyncSnapshot<List<Address>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if(snapshot.data == null)
              {
                isVeryfied = false ;
                isVerifying = false;
                prefs.setString('userID',null);
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'You Need to verify Again',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
            else if (snapshot.data == null || snapshot.data.length == 0) {
              // done with no data
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  'You don\'t have existing ddresses',
                  style: TextStyle(fontSize: 18),
                ),
              );
            } else {
              // done with data
              return Container(
                height: 250,
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      title: Text(snapshot.data[index].line1),
                      onTap: () {
                        _addressProvider
                            .setUserAddressId(snapshot.data[index].id)
                            .whenComplete(() async {
                          SharedPreferences shared =
                              await SharedPreferences.getInstance();
                          shared.setString('current_addressLine',
                              snapshot.data[index].line1);
                        }).then((_) {
                          print('${snapshot.data[index].id}');
                          setState(() {
                            locationSaved = 3;
                          });
                          Navigator.of(context).pop();
                        });
                      },
                    );
                  },
                ),
              );
            }
          } else {
            // still loading
            return buildLoadingIndicator();
          }
        });
  }

  Widget buildLoadingIndicator() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircularProgressIndicator(),
          Text('Still loading previous addresses'),
        ],
      ),
    );
  }

  Widget buildCompleteLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
        CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.location_on,
            color: Colors.white,
            size: 20,
          ),
        ),
        Container(
          width: 250,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Location set',
              style: TextStyle(fontSize: 18, color: Colors.green),
            ),
          ),
        )
      ],
    );
  }

  Widget buildDateRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
        CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(
            Icons.event,
            color: Colors.white,
            size: 20,
          ),
        ),
        Container(
          width: 270,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              DateFormat.yMMMMEEEEd().format(DateTime.parse(dateSaved)),
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),
          ),
        )
      ],
    );
  }

  Future<bool> showDatePickerBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: <Widget>[
              Container(
                height: 50.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences shared =
                            await SharedPreferences.getInstance();
                        shared.setString('date', '');
                        setState(() {
                          dateCanceled = true;
                          dateSaved = '';
                          print('date canceled is $dateCanceled');
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 50.0,
                        padding: EdgeInsets.only(
                          left: 10.0,
                          right: 10.0,
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Done',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: CupertinoDatePicker(


                    initialDateTime: DateTime.now().add(new Duration(hours: 1)),

                    onDateTimeChanged: (DateTime newDate) async {
                      String date = newDate.toIso8601String();
                      print("Date: $date");
                      SharedPreferences shared =
                          await SharedPreferences.getInstance();
                      shared.setString('date', date);
                      setState(() {
                        dateSaved = date;
                        isScheduled = true;
                        isPriority = false;
                        dateCanceled = false;
                      });
                    },
                    use24hFormat: false,
                   minimumDate: DateTime.now().subtract(Duration(days:1)),
                   
                    minimumYear: 2019,
                    maximumYear: 2019,
                    minuteInterval: 1,
                    mode: CupertinoDatePickerMode.dateAndTime,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<bool> showVerificationDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          backgroundColor: Colors.white,
          content: Stack(
            overflow: Overflow.visible,
            //textDirection: TextDirection.ltr,
            children: <Widget>[
              Container(
                width: 150.0,
                height: 230.0,
              ),
              Positioned(
                right: 15.0,
                top: 15.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                  ),
                ),
              ),
              Positioned(
                top: 45.0,
                left: 40.0,
                right: 40.0,
                child: FutureBuilder(
                  future:
                      prefsDataProvider.getLabelFromKey(LABEL_ENTER_PIN_CODE),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey[700],
                        ),
                      );
                    return Container();
                  },
                ),
              ),
              Positioned(
                top: 120.0,
                left: 60.0,
                child: VerificationCodeInput(
                  itemSize: 35,
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                  keyboardType: TextInputType.number,
                  length: 4,
                  onCompleted: (String value) {
                    verificationCode = value;
                  },
                ),
              ),
              Positioned(
                left: 30.0,
                right: 30.0,
                bottom: 15.0,
                child: Container(
                  height: 45,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: RaisedButton(
                      color: Colors.blue[900],
                      elevation: 2.0,
                      onPressed: () async {
                        setState(() {
                          isConfirming = true;
                        });
                        _user.confirmUser(verificationCode).whenComplete(() {
                          //rehister token for push.
                          _user.registerPushToken().then((value) {
                            if (value == '111') {
                              setState(() {
                                snackBar(scaffoldKey, "msg_111");
                              });
                            } else {
                              setState(() {
                                if (value != null) {
                                  snackBar(scaffoldKey, value);
                                } else {
                                  snackBar(scaffoldKey, Label_INVALID_CODE);
                                }
                              });
                            }
                          });
                        }).whenComplete((){
                          requestVistProvider.activeRequests().then((value){
                             activeRequests = value;
                             if(activeRequests!=null && activeRequests.length > 0)
                                   _showDialog();
                          });
                        }).then((result) {
                          print('User authentication result $result');
                          if (result == '111') {
                            prefs.setString('phone', phoneNumber);
                            prefs.setString('userName', userName);
                            setState(() {
                              isVeryfied = true;
                              isConfirming = false;
                            });
                          }
                          Navigator.pop(context);
                        });
                      },
                      child: FutureBuilder(
                        future: prefsDataProvider.getLabelFromKey(Label_NEXT),
                        builder: (context, snapshot) {
                          if (snapshot.hasData)
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            );
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildNextButton(double _width, double _height, bool state) {
    bool hasLocation = locationSaved != -1;
    return Positioned(
      left: _width * 0.1,
      top: _height * 0.85,
      height: 60,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: () {
            if (!isScheduled && !isPriority) {
              snackBar(scaffoldKey, "Select Visit Type or Specify Date");
              return;
            }
            if (state && locationSaved == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentConfirmation()));
            } else {
              snackBar(scaffoldKey, Label_SET_YOUR_LOCATION);
            }
          },
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_NEXT),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                );
              return Container();
            },
          ),
          color: state && hasLocation ? Colors.blue : Colors.grey,
          minWidth: _width * 0.8,
        ),
      ),
    );
  }

  Future<String> getCurrentSavedAddress() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String current_address = shared.get('current_addressLine');
    return current_address;
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_existing_visit_title),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                  ),
                );
              return Container();
            },
          ),
          content: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_existing_visit_content),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                );
              return Container();
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: FutureBuilder(
                future: prefsDataProvider.getLabelFromKey(Label_existing_visit_ok),
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Text(
                      snapshot.data,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                      ),
                    );
                  return Container();
                },
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => Home()));
              },
            ),
          ],
        );
      },
    );
  }

}
