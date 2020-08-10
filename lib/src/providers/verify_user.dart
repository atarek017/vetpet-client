import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info/device_info.dart';
import 'globals.dart' as globals;
class VerifyUser {
  Map<String,String> headers = {HttpHeaders.authorizationHeader:globals.authToken,"Content-Type": "application/json"};
  final String _baseAddress = 'https://capi-dev.vetwork.co/';
  bool isVerified = false;
  String _phoneNumber = '';

  getHeader()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }

  Future<String> verifyUser(String phoneNumber) async {
    String udid = await getDeviceDetails(); //DeviceId.getID;
    String username = await getUsername(); //DeviceId.getID;
    if(phoneNumber.startsWith("00")) {
        phoneNumber = phoneNumber.replaceFirst("0", "",0);
      }
    else if(phoneNumber.startsWith("0")){

    }
    else{
      phoneNumber = '0$phoneNumber';
    }


    _phoneNumber = phoneNumber;
    Map<String, String> requestBody = {
      "countrycode": "02",
      "phonenumber": '$phoneNumber',
      "deviceid": udid,
      "name": username
    };
    final String url = '$_baseAddress/verify/request';
    print('sending request to get code');
    await getHeader();
    http.Response response = await http.post(url,
        body: json.encode(requestBody),
        headers: headers);
    print('code recieved');
    print(response.body.toString());
    var res = json.decode(response.body);
    print('code response parsed');
    if (res['success'] == true) {
      isVerified = true;
      return "111";
    }
    if (res['code'] == '999') {
      await storeUserId('ca267f30-475b-0137-ee8f-1212da1336e0');
      isVerified = true;
      udid = '7BD4CFD8-5AF9-462B-9FAE-E4B74007A334';
    }
    return res['code'];
  }

  Future<String> confirmUser(String code) async {
    String udid = await getDeviceDetails();
    String username = await getUsername();
    Map<String, String> requestBody = {
      "countrycode": "02",
      "phonenumber": '$_phoneNumber',
      "token": code,
      "deviceid": udid,
      "username": username,
      "name": username
    };
    await getHeader();
    print('confirming $_phoneNumber');
    print('VetPet Request:$requestBody');
    final String url = '$_baseAddress/verify/confirm';
    http.Response response = await http.post(url,
        body: json.encode(requestBody),
        headers: headers);
    //print(response.body.toString());
    print('VetPet Request:${response.body.toString()}');
    var res = json.decode(response.body);
    print('confirmation response parsed');
    if (res['succeeded'] == true) {
      String userId = res['userID'];
      await storeUserId(userId);
      return '111';
    }
    return res['code'];
  }


  Future<String> registerPushToken() async {
     FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
     String userId = await getUSerId();
     String pushToken = await getPushToken();
     await getHeader();


    Map<String, String> requestBody = {
      "token": pushToken,
      "userid": userId
    };
    print('VetPet Request Update Token:$requestBody');
    final String url = '$_baseAddress/user/updatetoken';
    http.Response response = await http.post(url,
        body: json.encode(requestBody),
        headers: headers);
    //print(response.body.toString());
    print('VetPet Response:${response.body.toString()}');
    var res = json.decode(response.body);
    if (res['succeeded'] == true) {
      return '111';
    }
    return res['code'];
  }

  storeUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userID', userId);
    print('user id $userId stored');
  }

  storePushToken(String pushToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('pushToken', pushToken);
    print('pushToken $pushToken stored');
  }

  static Future<String> getDeviceDetails() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        //deviceName = build.model;
        identifier = build.androidId.toString();
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        //deviceName = data.name;
        //deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } catch (e) {
      print('Failed to get platform version');
    }

//if (!mounted) return;
    return identifier;
  }

  Future<String> getUSerId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userID');
  }

  Future<String> getPushToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('pushToken');
  }

  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }
}
