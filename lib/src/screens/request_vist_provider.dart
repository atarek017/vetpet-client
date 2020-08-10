import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/models/active_request.dart';

class RequestVistProvider {
  String userId = '';
  int addressId = 0;
  int petid = 0;
  int petType = 0;
  List<int> ser = [];
  String date = '';
  bool scheduleVisit = true;

  Future<String> requestVisit() async {
    _getUserId();
    print("userId");
    print(userId);

    await _getAddressId();
    print("addressId");
    print(addressId);

    _getSchedualeVisit();
    print("scheduleVisit");
    print(scheduleVisit);

    await _getservices();
    await _getpetId();
    await _getPetType();
    await _getData();

    Map<String, dynamic> requestBody = {
      "userid": userId,
      "petId": petid,
      "sizeId": null,
      "reqTypId": 1,
      "petTypId": petType,
      "svcIds": ser,
      "comment": null,
      "VisitTime": date,
      "addressId": addressId,
      "country_iso": "EG"
    };

    print(requestBody.toString());

    http.Response response = await http.post("https://capi-dev.vetwork.co/visit/request",
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"});

    print(response.body.toString());

    var res = json.decode(response.body);
    print(res.toString());

    if (res['success'] == true) {
      _saveRequestVisitId(res['paras']['visitid']);
      return '111';
    }
    return res['code'];
  }

  Future<List<ActiveRequests>> activeRequests() async {
    List<ActiveRequests> activeRequests = [];

    var url = "https://capi-dev.vetwork.co/user/activerequests";
    var body = json.encode({
      "userid": userId.toString(),
    });

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);

    final responseJson = json.decode(response.body);
    print(responseJson.toString());

    if (responseJson["success"] == true) {
      List<dynamic> getRequests = responseJson['paras']['requests'];
      activeRequests = getRequests
          .map((activeRequests) => ActiveRequests.fromJson(activeRequests))
          .toList();
    }

    return activeRequests;
  }

  Future<bool> visitPrice() async {
    await _getUserId();

    Map<String, dynamic> requestBody = {
      "userid": userId,
      "svcIds": [1, 2, 3],
      "VisitTime": "2019-03-29T09:00:00",
      "country_iso": "EG"
    };

    print(requestBody.toString());

    http.Response response = await http.post("https://capi-dev.vetwork.co/visit/Price",
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"});

    print(response.body.toString());

    var res = json.decode(response.body);

    if (res['success'] == true) {
      // todo: get service price
      return true;
    }
    return false;
  }

  Future<bool> requestStatus() async {
    _getUserId();
    print("userId");
    print(userId);

    Map<String, dynamic> requestBody = {"userid": userId, "id": 22};

    print(requestBody.toString());

    http.Response response = await http.post(
        "https://capi-dev.vetwork.co/visit/requeststatus",
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"});

    print(response.body.toString());

    var res = json.decode(response.body);

    if (res['success'] == true) {
      //todo : get state
      return true;
    }
    return false;
  }

  _getAddressId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    addressId = prefs.getInt("adressid");
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userID");
  }

  _getSchedualeVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    scheduleVisit = prefs.getBool("scheduleVisit");
    if (scheduleVisit == null) {
      scheduleVisit = true;
    }
  }

  _getservices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String services = preferences.getString("services");

    List<String> strService = services.split('-');
    for (String x in strService) {
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
    petType = preferences.getInt("petType");
  }

  _getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    date = preferences.getString("date");
  }

  _saveRequestVisitId(int visitId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("visitid", visitId);
  }
}
