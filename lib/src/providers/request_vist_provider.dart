
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/models/active_request.dart';
import 'authentiction.dart';
import 'globals.dart' as globals;

class RequestVistProvider {
  String userId = '';
  int petid = 0;
  int petSizeid;
  int reqTypId=0;
  int petType = 0;
  List<int> ser = [];
  String date = '';
  int addressId = 0;
  Map<String,String> headers = {HttpHeaders.authorizationHeader:globals.authToken,"Content-Type": "application/json"};

  getHeader()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }
  Future<String> requestVisit() async {
    await _getUserId();
    await _getpetId();
    await _getpetSizeId();
    await _getReqTypId();
    await _getPetType();
    await _getservices();
    await _getData();
    await _getAddressId();
    await getHeader();



    if (petid == null) {
      petid = null;
      print("petID: $petid");
    }

    Map<String, dynamic> requestBody = {
      "userid": userId,
      "petId": petid,
      "sizeId": petSizeid,
      "reqTypId": reqTypId,
      "petTypId": petType,
      "svcIds": ser,
      "comment": null,
      "VisitTime": date,
      "addressId": addressId,
      "country_iso": "EG"
    };

  //  print(requestBody.toString());
    print('VetPet Request:${requestBody.toString()}');

    http.Response response = await http.post("https://capi-dev.vetwork.co/visit/request",
        body: json.encode(requestBody),
        headers: headers);

    print(response.body.toString());
    print('VetPet Request:${response.body.toString()}');

    var res = json.decode(response.body);
    print(res.toString());

    if (res['success'] == true) {
      _saveRequestVisitId(res['paras']['visitid']);
      //_deleteData();
      return '111';
    }
    return res['code'];
  }

  Future<List<ActiveRequests>> activeRequests() async {
    await _getUserId();
    await getHeader();
    List<ActiveRequests> activeRequests = [];

    if(userId=='' || userId==null || userId.length==0){
      return activeRequests;
    }

    var url = "https://capi-dev.vetwork.co/user/activerequests";
    var body = json.encode({
      "userid": userId.toString(),
    });

    Authentication authentication = Authentication();
    //String authtoken  = await authentication.authenticate();
    final response = await http.post(url, body: body, headers: headers);

    final responseJson = json.decode(response.body);
    print(responseJson.toString());

    if(responseJson == "900")
       return activeRequests;
    if (responseJson["success"] == true && responseJson['paras']!=null) {
    List<dynamic>  getRequests = responseJson['paras']['requests'];
      activeRequests = getRequests
          .map((activeRequests) => ActiveRequests.fromJson(activeRequests))
          .toList();
    }

    return activeRequests;
  }

  _getAddressId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    addressId = prefs.getInt("adressid");
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userID");
  }


  _getservices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String services = preferences.getString("services");

    List<String> strService = services.split('-');
    String x;
    for (x in strService) {
      if (x.isNotEmpty && x != ' ' && x != null) {
        ser.add(int.parse(x));
      }
    }
    print('this is services ${ser.toString()}');
  }

  _getpetId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    petid = preferences.getInt("petID");
  }

  _getPetType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String specie = preferences.getString("specie");
    if(specie=='dog')
      petType=1;
    if(specie=='cat')
      petType=2;

  }

  _getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    date = preferences.getString("date");
    print("VetPet Request Service:$date");
  }


  _getpetSizeId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    petSizeid = preferences.getInt('petSizeId');
  }

  _getReqTypId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String serve =preferences.getString('service');
    if(serve=='Healthcare')
      reqTypId=1;
    if(serve=='Grooming')
      reqTypId=2;
  }

  _saveRequestVisitId(int visitId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("visitid", visitId);
  }

  _deleteData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("date",null);
    await preferences.setInt("petID",null);
    await preferences.setInt('petSizeId',null);
    await preferences.setInt('service',null);
    await preferences.setInt('specie',null);
    await preferences.setString('services',null);
  }


}
