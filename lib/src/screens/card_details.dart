import 'package:flutter/material.dart';
import 'package:vetwork_app/src/widgets/background_container.dart';
import 'package:vetwork_app/src/widgets/blueCircle.dart';
import 'package:vetwork_app/src/widgets/custom_checkbox.dart';

class CardDetails extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CardDetailsState();
  }
}

class CardDetailsState extends State<CardDetails>  {
  final formKey = GlobalKey<FormState>();
  var _months=["January","February","March","April","May","June","July","August","September","October","November","December"] ;
  var _monthsItemSelected="January";

  var _years=["2020","2019","2018","2017","2018","2016","2015","2014","2013"] ;
  var _yearsItemSelected="2019";


  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final double _height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Stack(children: <Widget>[
      BackgroundContainer(),
      Positioned(
        top: _height * 0.8,
        left: _width * 0.65,
        child: BlueCircle(),
      ),
      buildContent(_width),
      buildSubmitButton(_width, _height),
    ]));
  }

  Widget buildContent(double screenWidth) {
    return ListView(
      children: <Widget>[
        buildCloseButton(),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.only(left: 20),
          child: Text(
            'Card details',
            textAlign: TextAlign.start,
            style: TextStyle(
                color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Add your card details. You will be prompt again to confirm payment.',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset(
            'assets/pics/credit_card.png',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        inputsFields(),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Text("EPIRY DATE",style:  TextStyle(color: Colors.blueAccent, fontSize: 20,),
          ),
        ),
    Container(
    margin: EdgeInsets.symmetric(horizontal: 20),
      child: expiryDate(),
    ),
        SizedBox(
          height: 25,
        ),
        CustomCheckBox(title: 'set as defult payment', value: true),
        SizedBox(
          height: 70,
        ),
      ],
    );
  }

  Widget inputsFields() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            cardNumber(),
            SizedBox(
              height: 20,
            ),
           Row(
             children: <Widget>[
               nameOfCard(),
               SizedBox(width: 20,),
               cvc(),
             ],
           )
          ],
        ),
      ),
    );
  }

  Widget cardNumber() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'CARD NUMBER',
        hintText: ' 1111 2222 3333 9999 ',
        labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 20),
        hintStyle: TextStyle(color: Colors.black),
        suffix: Image.asset(
          "assets/pics/visa.png",
          width: 50,
          height: 30,
        ),
      ),
    );
  }

  Widget nameOfCard() {
    return Container(
      width: 190,
      child: TextFormField(
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          labelText: 'NAME OF THE CARD ',
          hintText: 'Chandlar M.Bing ',
          labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 20),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget cvc() {
    return Container(
      width: 60,
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'CVC ',
          hintText: '123',
          labelStyle: TextStyle(color: Colors.blueAccent, fontSize: 20),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Align buildCloseButton() {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 20),
        child: IconButton(
            icon: Icon(
              Icons.close,
              size: 50,
            ),
            onPressed: () {
              /* TODO add action*/
            }),
      ),
    );
  }


  Widget expiryDate(){
    return Row(

      children: <Widget>[
        DropdownButton<String>(
            items:_months.map((String dropDowenItem){
                  return  DropdownMenuItem<String>(
                    value: dropDowenItem,
                    child: Text(dropDowenItem),
                  );
                }).toList(),
            onChanged: (String newValue){
                setState((){
                    _monthsItemSelected=newValue;
                  });
                },
            value: _monthsItemSelected,
        ),

        SizedBox(width: 100,),

        DropdownButton<String>(
          items:_years.map((String dropDowenItem){
            return  DropdownMenuItem<String>(
              value: dropDowenItem,
              child: Text(dropDowenItem),
            );
          }).toList(),
          onChanged: (String newValue){
            setState((){
              _yearsItemSelected=newValue;
            });
          },
          value: _yearsItemSelected,
        ),

      ],
    );
  }
  Positioned buildSubmitButton(double _width, double _height) {
    return Positioned(
      left: _width * 0.45,
      top: _height * 0.85,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.check,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
      ),
    );
  }
}
