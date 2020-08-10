
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'authentiction.dart';
import 'globals.dart' as globals;

class RequestStatus {
  final String _baseAddress = 'https://capi-dev.vetwork.co/';
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: globals.authToken,
    "Content-Type": "application/json"
  };

  getHeader()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }

  Future<int> getRequestStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = await prefs.get('userID') ?? '';
    Authentication authentication = Authentication();
    //await authentication.authenticate();
    var auth = prefs.getString('authToken');
    await getHeader();

    var requestID = await prefs.get('visitid') ?? '';

    Map<String, String> requestBody = {
      "userid": userId,
      "id": requestID.toString(),
    };

    http.Response response = await http.post(
      '$_baseAddress/user/requeststatus',
      body: json.encode(requestBody),
      headers: headers,
    );
    var res ;
    if (response.statusCode == 200) {
      res = json.decode(response.body);
      if (res['success'] == true) return res['paras']['statusId'];
      return int.parse(res['code']);
    }
    return int.parse(res['code']);
  }
}

String fakeResponse =
    " {\"success\": true,\"code\": \"111\",\"paras\": {\"statusId\": 3}}";
