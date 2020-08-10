import 'package:flutter/material.dart';
import 'package:vetwork_app/src/LocalizaionConstants.dart';
import 'package:vetwork_app/src/ServicePricesModel.dart';
import 'package:vetwork_app/src/screens/card_details.dart';
import 'package:vetwork_app/src/screens/home.dart';
import 'package:vetwork_app/src/screens/save_your_pit.dart';
import 'package:vetwork_app/src/screens/status_route.dart';
import '../widgets/background_container.dart';
import '../widgets/blueCircle.dart';
import '../widgets/back_chip.dart';
import '../widgets/cancel_chip.dart';
import '../providers/request_vist_provider.dart';
import '../providers/prices_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../mixins/preferences_keys_mixin.dart';
import '../providers/preference_data_provider.dart';
import 'add_pet.dart';

class PaymentConfirmation extends StatefulWidget {
  @override
  _PaymentConfirmationState createState() => _PaymentConfirmationState();
}

class _PaymentConfirmationState extends State<PaymentConfirmation>
    with PreferencesKeysMixin {
  bool _checkBoxValue = false;
  bool _cashCheckBoxValue = true;
  PricesProvider pricesProvider = PricesProvider();
  List<int> services = [];
  List<double> prices = [];
  bool isLoading = true;
  PreferenceDataProvider preferenceProvider = PreferenceDataProvider();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  ServicePricesModel model;

  int petSizeId;

  @override
  void initState() {
    super.initState();
    getServices();
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
            Padding(
              padding: EdgeInsets.only(left: 20, right: _width < 600 ? 10 : 50),
              child: buildBody(),
            ),
            buildSubmitButton(_width, _height, context),
            // buildSavePitButton(_width, _height, context),
          ],
        ));
  }

  getServices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String allServices = preferences.getString("services");
    String date = preferences.getString("date");
    await preferences.setString("services_", allServices);
    await preferences.setString("date_", date);
    petSizeId = preferences.getInt('petSizeId');

    List<String> strService = allServices.split('-');
    for (String x in strService) {
      if (x.isNotEmpty && x != ' ' && x != '' && x != null) {
        services.add(int.parse(x));
      }
    }
    services.sort();
    model = await pricesProvider.getPrices(services, scaffoldKey);
    for (int i = 0; i < model.paras.prices.length; i++) {
      prices.add(model.paras.prices[i].price.toDouble());
    }

//    if(model.paras.regular !=null ) {
//      strService.add("Regukar");
//      prices.add(model.paras.regular.fees.toDouble());
//    }
//
//    if(model.paras.extra !=null ) {
//      strService.add("Extra");
//      prices.add(model.paras.extra.fees.toDouble());
//    }

    setState(() {
      isLoading = false;
      prices = prices;
    });
    print('sorted ser ${strService.toString()}');
    print('sorted ser ${prices.toString()}');
  }

  Widget buildBody() {
    return ListView(
      children: <Widget>[
        SizedBox(height: 25),
        Row(
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
        SizedBox(height: 30),

        FutureBuilder(
          future: preferenceProvider.getLabelFromKey(Label_SELECTED_SERVICES),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Text(
                snapshot.data,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              );
            return Container();
          },
        ),

        SizedBox(height: 20),
        isLoading
            ? Container(
                width: 300,
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : buildPricingRow(model),
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
        SizedBox(height: 30),

        FutureBuilder(
          future: preferenceProvider.getLabelFromKey(Label_PAYMENT_METHID),
          builder: (context, snapshot) {
            if (snapshot.hasData)
              return Text(
                snapshot.data,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              );
            return Container();
          },
        ),

        SizedBox(height: 20),
        buildCashRow(),
        // buildCreditRow(),
        SizedBox(height: 20),
        //buildAddNewCardRow(),
        //SizedBox(height: 170),
      ],
    );
  }

  Row buildAddNewCardRow() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.black,
          child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              onPressed: null),
        ),
        FlatButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CardDetails()));
            },
            child: Text(
              'Add new card',
              style: TextStyle(fontSize: 18),
            ))
      ],
    );
  }

  buildPricingRow(ServicePricesModel model) {
    var row = Row(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: services
                .map((ser) => Column(
                      children: <Widget>[
                        FutureBuilder(
                            future: preferenceProvider.getServiceLabel(ser),
                            builder: (context, snapShot) {
                              if (snapShot.hasData)
                                return formattedText(snapShot.data);
                              return Container(height: 1);
                            }),
                        SizedBox(height: 18),
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
                      formattedText('$ser EGP',
                          color: Colors.black, bold: true),
                      SizedBox(height: 20),
                    ],
                  ))
              .toList(),
        ),
        SizedBox(width: 30),

        //Row(children: <Widget>[],)
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        row,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isExtra(model)
                ? FutureBuilder(
                    future: preferenceProvider.getLabelFromKey(Label_EXTRA),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return Text(
                          snapshot.data,
                        );
                      return Container();
                    },
                  )
                : Text(""),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: isExtra(model)
                  ? formattedText('${model.paras.extra.fees.toString()} EGP')
                  : Text(""),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            isRegular(model)
                ? FutureBuilder(
                    future: preferenceProvider.getLabelFromKey(Label_REGULAR),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return Text(
                          snapshot.data,
                        );
                      return Container();
                    },
                  )
                : Text(""),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
              child: isRegular(model)
                  ? formattedText('${model.paras.regular.fees.toString()} EGP')
                  : Text(""),
            ),
          ],
        ),
      ],
    );
  }

  Row buildCashRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Checkbox(
            value: _cashCheckBoxValue,
            onChanged: (newValue) {
              setState(() {
                _cashCheckBoxValue = newValue;
              });
            }),
        FlatButton(
          onPressed: () {
            setState(() {
              _cashCheckBoxValue = !_cashCheckBoxValue;
            });
          },
          child: FutureBuilder(
            future: preferenceProvider.getLabelFromKey("cash"),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(color: Colors.green, fontSize: 18),
                );
              return Container();
            },
          ),
        ),
      ],
    );
  }

  Row buildCreditRow() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Checkbox(
            activeColor: Colors.green,
            value: _checkBoxValue,
            onChanged: (newValue) {}),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
                onPressed: () {},
                child: Text(
                  'Credit Card',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                )),
            Text(
              'card ending in **** **** **** 1421',
              style: TextStyle(fontSize: 16),
            )
          ],
        )
      ],
    );
  }

  Widget formattedText(String text,
      {Color color = Colors.black54, bool bold = false}) {
    return Text(
      text,
      textAlign: TextAlign.start,
      style:
          TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.normal),
    );
  }

  Widget buildSubmitButton(double _width, double _height, context) {
    RequestVistProvider requestVistProvider = new RequestVistProvider();

    return Positioned(
      left: _width * 0.1,
      top: _height * 0.90,
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: () async {
            String respond = await requestVistProvider.requestVisit();
            if (respond == '912') {
              _showDialog();
            }
            else if (respond != '111') {
              snackBar(scaffoldKey, respond);
            }
            else
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StatusRoute()));
          },
          child: FutureBuilder(
            future: preferenceProvider.getLabelFromKey(Label_CONFIRM),
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return Text(
                  snapshot.data,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                );
              return Container();
            },
          ),
          color: Colors.blue[900],
          minWidth: _width * 0.8,
        ),
      ),
    );
  }

  Widget buildSavePitButton(double _width, double _height, context) {
    return Positioned(
      left: _width * 0.1,
      top: _height * 0.82,
      height: 45,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPet()));
          },
          child: Text(
            'Save your Pثt',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Colors.blue[900],
          minWidth: _width * 0.8,
        ),
      ),
    );
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


  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Alert"),
          content: new Text("Active Visit  exist"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()));
              },
            ),
          ],
        );
      },
    );
  }

}
