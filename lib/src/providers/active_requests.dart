import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/providers/authentiction.dart';
import 'globals.dart' as globals;

class ActiveRequest {
  final String _baseAddress = 'https://capi.vetwork.co/';
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: globals.authToken,
    "Content-Type": "application/json"
  };

  getHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }

  Future<bool> checkHasActiveRequests(String userId) async {
     print('Active Request Called');
    await getHeader();
    Map<String, String> requestBody = {"userid": "$userId"};
    print('VetPet Request:$requestBody');
    http.Response response = await http.post(
        '$_baseAddress/user/activerequests',
        body: json.encode(requestBody),
        headers: headers);
    print('${response.body}');    
    print('Active Request Response Code :${response.statusCode}');
    if (response.statusCode == 200) { 
       print('Active Request Authenticated ${response.statusCode}');
      String fixed = response.body.replaceAll(r"\'", "'");
      var res = jsonDecode(fixed);
      print('VetPet response:$res');
      if (res == 900) {
        return false;
      }
      if (res['paras'] != null) {
         print('Found Active Request');
        if (res['paras']['requests'].length >= 1) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'visitid', res['paras']['requests'][0]['id'].toString());
          return true;
        }
      }
       print('No Active Request');
      return false;
    } else if (response.statusCode == 401) {
       print('Active Request not Authenticated ${response.statusCode}');
        return true;
    //    print('Start Authentication');
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String id = (prefs.getString('userID') ?? '');
    //   Authentication().authenticate().then((value) {
    //     print('ReAuthentication Happened');
    //     checkHasActiveRequests(id);
    //   });
    // }
  }
}

String value =
    "{\"success\": true, \"code\": \"111\", \"paras\": {\"requests\": [{\"id\": 21, \"statusId\": 1, \"address\": {\"id\": 8, \"isDefault\": false, \"line1\": \"123\", \"line2\": \"456\", \"state\": \"cairo\", \"city\": \"nasr city\", \"postalcode\": null, \"countryIso\": \"EG\", \"location\": \"30.0579605,31.2042034\"}}]}}";
}