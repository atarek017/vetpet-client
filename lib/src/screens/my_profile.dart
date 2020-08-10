import 'package:flutter/material.dart';
import 'package:flutter_verification_code_input/flutter_verification_code_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/mixins/preferences_keys_mixin.dart';
import 'package:vetwork_app/src/models/address.dart';
import 'package:vetwork_app/src/providers/address_provider.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';
import 'package:vetwork_app/src/providers/verify_user.dart';
import 'package:vetwork_app/src/widgets/background_container.dart';
import 'package:vetwork_app/src/widgets/blueCircle.dart';
import 'package:vetwork_app/src/widgets/map_dialog.dart';

import '../LocalizaionConstants.dart';

class MyProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyProfileState();
  }
}

class _MyProfileState extends State<MyProfile> with PreferencesKeysMixin {
  SharedPreferences pre;

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isVeryfied = false;
  bool isVerifying = false;
  bool isConfirming = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  String phoneNumber = '';
  String userName = '';
  VerifyUser _user = VerifyUser();
  String verificationCode;
  bool loadingAddress = true;
  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();
  int numPoints = 0;
  AddressProvider addressProvider = AddressProvider();

  List<Address> addresses = [];
  int addressId;

  String nameValidation;
  String nameInput;
  String nameHintInput;

  String mobileInput;
  String mobileHintInput;
  String mobileValidation;

  @override
  void initState() {
    super.initState();

    initialState();
  }

  initialState() async {
    nameValidation = await prefsDataProvider.getLabelFromKey(Label_VALIDATION);
    nameInput = await prefsDataProvider.getLabelFromKey(Label_NAME);
    nameHintInput = await prefsDataProvider.getLabelFromKey(Label_NAME_HINT);

    mobileInput = await prefsDataProvider.getLabelFromKey(Label_MOBILE);
    mobileHintInput =
        await prefsDataProvider.getLabelFromKey(Label_MOBILE_HINT);
    mobileValidation =
        await prefsDataProvider.getLabelFromKey(Label_MOBILE_VALIDATION);
    pre = await SharedPreferences.getInstance();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.getString('userID') ?? '';
    addressId = await prefs.getInt('adressid');

    if (userId != null && userId != '') {
      userName = await prefs.getString('userName');
      phoneNumber = await prefs.getString('phone');
      setState(() {
        nameController.text = userName;
        phoneController.text = phoneNumber;
        isVeryfied = true;
      });
    }
    addresses = await addressProvider.getAddress();
    loadingAddress = false;
    print("addressId: $addressId");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: scaffoldKey,
      body: Container(
        width: _width,
        height: _height,
        child: Stack(
          children: <Widget>[
            BackgroundContainer(),
            Positioned(
              top: _height * 0.8,
              left: _width * 0.65,
              child: BlueCircle(),
            ),
            buildBody(),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.only(left: 20, right: 20),
          children: <Widget>[
            SizedBox(height: 80),
            FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("my_points"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

                return Container();
              },
            ),
            SizedBox(height: 20),
            FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("you_have_points"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data + " " + numPoints.toString(),
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]));
                return Container();
              },
            ),
            FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("invite_pepole"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]));
                return Container();
              },
            ),
            SizedBox(height: 20),
            invitationCode(),
            SizedBox(height: 20),
            FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("personal_information"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data,
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]));
                return Container();
              },
            ),
            SizedBox(
              height: 20,
            ),
            personalInformation(),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: prefsDataProvider.getLabelFromKey(Label_Your_Address),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(snapshot.data,
                      textAlign: TextAlign.start,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold));

                return Container();
              },
            ),
            SizedBox(
              height: 10,
            ),
            address(),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: EdgeInsets.only(right: 100, left: 50),
                child: addNewAdd()),
            SizedBox(
              height: 100,
            ),
          ],
        ),
        Positioned(top: 40, child: buildCustomAppBar()),
        Positioned(bottom: 40, right: 30, left: 30, child: save()),
        Positioned(bottom: 10, right: 30, left: 30, child: cancel()),
      ],
    );
  }

  Row buildCustomAppBar() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 20),
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.keyboard_backspace, color: Colors.black)),
        SizedBox(width: 20),
        Icon(Icons.person_pin, color: Colors.black),
        SizedBox(width: 10),
        FutureBuilder(
          future: prefsDataProvider.getLabelFromKey("my_profile"),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Text(snapshot.data,
                  style: TextStyle(color: Colors.black, fontSize: 20));

            return Container();
          },
        )
      ],
    );
  }

  Widget invitationCode() {
    return Column(
      children: <Widget>[
        Container(
          height: 10,
          width: 350,
          color: Colors.blue[900],
        ),
        Container(
          height: 170,
          width: 350,
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 7.0, color: Colors.grey)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: FutureBuilder(
                  future: prefsDataProvider.getLabelFromKey("invitation_code"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(snapshot.data,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold));
                    return Container();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: FutureBuilder(
                  future: prefsDataProvider
                      .getLabelFromKey("use_this_invitation_code"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data,
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                      );
                    return Container();
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  height: 40,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text("JOME10FF10%",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget personalInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                                pre.setString('userName', userName);
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
      ],
    );
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
              textDirection: TextDirection.ltr,
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
                  child: Text(
                    'Enter the PIN code that has been sent to you via SMS',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[700],
                    ),
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
                  child: isConfirming
                      ? Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(),
                        )
                      : Container(
                          height: 45,
                          width: 200,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            child: RaisedButton(
                              color: Colors.blue[900],
                              elevation: 2.0,
                              onPressed: () async {
                                setState(() {
                                  isConfirming = true;
                                });
                                String result =
                                    await _user.confirmUser(verificationCode);
                                print('User authentication result $result');
                                if (result == '111') {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setString('phone', phoneNumber);
                                  prefs.setString('userName', userName);
                                  setState(() {
                                    isVeryfied = true;
                                    isConfirming = false;
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: Text(
                                'NEXT',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
                Positioned(
                  bottom: -35.0,
                  left: 0.0,
                  child: Container(
                    width: 270.0,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text('Resend code',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          )),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget address() {
    return loadingAddress == false
        ? Container(
            height: 200,
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (BuildContext context, int index) {
                return addressSlot(index);
              },
            ),
          )
        : Container(
            child: CircularProgressIndicator(),
          );
  }

  Widget addressSlot(int index) {
    return InkWell(
      onTap: () async {
        addressId = addresses[index].id;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.check_circle,
                color: addressId == addresses[index].id
                    ? Colors.green
                    : Colors.grey[300]),
            SizedBox(
              width: 20,
            ),
            Container(
              width: 270,
              height: 80,
              decoration: BoxDecoration(
                color: addressId == addresses[index].id
                    ? Colors.white
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          addresses[index].line1 +
                              " " +
                              addresses[index].line2 +
                              ", \n" +
                              addresses[index].city +
                              "," +
                              addresses[index].state +
                              "," +
                              addresses[index].countryIso,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          child: FutureBuilder(
                            future:
                                prefsDataProvider.getLabelFromKey(Label_Edit),
                            builder: (context, snapshot) {
                              if (snapshot.hasData)
                                return Text(
                                  snapshot.data,
                                );

                              return Container();
                            },
                          ),
                          onTap: () {},
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 2,
                          height: 10,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: FutureBuilder(
                            future:
                                prefsDataProvider.getLabelFromKey(Label_Delete),
                            builder: (context, snapshot) {
                              if (snapshot.hasData)
                                return Text(
                                  snapshot.data,
                                  style: TextStyle(color: Colors.red),
                                );

                              return Container();
                            },
                          ),
                          onTap: () {
                            addressProvider
                                .deleteAddress(addresses[index].id)
                                .then((onValue) {
                              setState(() {
                                addresses.removeWhere(
                                    (item) => item.id == addresses[index].id);
                              });
                            }).catchError((onError) {
                              print("Error" + onError.toString());
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addNewAdd() {
    MapDialog mapDialog = MapDialog(scaffoldKey);

    return InkWell(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_ADD_NEW_ADDRESS),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data + "   +",
                  textAlign: TextAlign.center,
                );

              return Container();
            },
          ),
        ),
      ),
      onTap: () {
        mapDialog.displayMapDialog(context);
      },
    );
  }

  Widget save() {
    return InkWell(
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue[900],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: FutureBuilder(
            future: prefsDataProvider.getLabelFromKey(Label_Save),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                );

              return Container();
            },
          ),
        ),
      ),
      onTap: () async {
        // here i save address id which user select from list of address
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt("adressid", addressId);
      },
    );
  }

  Widget cancel() {
    return InkWell(
      child: FutureBuilder(
        future: prefsDataProvider.getLabelFromKey(Label_CANCEL),
        builder: (context, snapshot) {
          if (snapshot.hasData)
            return Text(
              snapshot.data,
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            );

          return Container();
        },
      ),
    );
  }
}
