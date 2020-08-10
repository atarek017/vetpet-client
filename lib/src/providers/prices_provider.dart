
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/ServicePricesModel.dart';
import 'package:vetwork_app/src/mixins/preferences_keys_mixin.dart';
import 'globals.dart' as globals;

class PricesProvider   with PreferencesKeysMixin {
  final String _baseAddress = 'https://capi-dev.vetwork.co/';
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  Map<String,String> headers = {HttpHeaders.authorizationHeader:globals.authToken,"Content-Type": "application/json"};

  getHeader()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }

  getPrices(List<int> services,scaffoldKey ) async {
    List<double> prices = [];
    ServicePricesModel model;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.get('userID') ?? '';
    String date =  prefs.get('date') ;
    if(date == null)
       date = "2019-05-30T09:00:00" ;


    Map<String, dynamic> requestBody = {
      "userid": userId,
      "svcIds": services,
      "visitTime": date,
      "country_iso": "EG"
    };
    print('VetPet Request:$requestBody');
    await getHeader();
    http.Response response = await http.post('$_baseAddress/visit/Price',
        body: json.encode(requestBody),
        headers: headers);


    print('prices - ${response.body.toString()}');

    var res = json.decode(response.body);
    print('VetPet Request:$res');

    print('Hash Code : ${response.statusCode}');


    if(response.statusCode!=200){
      snackBar(scaffoldKey, res.toString());
      return null;
    }

    if(res['success']==false){
      snackBar(scaffoldKey, res['code']);
      return null;
    }
    model   =  ServicePricesModel.fromJson(res);
//    List<dynamic> pricesList = res['paras']['prices'];
//    for(var i in pricesList){
//      prices.add(i['price']);
//    }

    return model;
  }

}
