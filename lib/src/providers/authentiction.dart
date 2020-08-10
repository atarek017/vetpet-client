

import 'dart:io';

import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/home.dart';
import '../mixins/preferences_keys_mixin.dart';
import '../models/labels_api_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';
import 'globals.dart' as globals;

class Authentication extends Object with PreferencesKeysMixin {
  final String _baseAddress = 'https://capi.vetwork.co';
  final String _appId = 'FZB9368X-1DE3-4G4H-M62A-4C9Q26919S9A';
  List<Language> languages = [];

  Map<String,String> headers = {HttpHeaders.authorizationHeader:globals.authToken,"Content-Type": "application/json"};



  getHeader()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }


  Future<String> authenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
      // no auth token stored request new one
      String url = '$_baseAddress/auth/$_appId';
      http.Response response = await http.get(url);
      if(response.statusCode == 200) {
        var res = json.decode(response.body);
        if (res['success'] == true) {
          // if authenticated successfully store the token
          await storeUserToken(res['authToken']);
          globals.authToken = res['authToken'];
          await getHeader();// Set Auth Token.
        } else {
          return res['code'];
        }
      }
    return '222';
  }

  Future<bool> checkLngVersion() async {
    final String url = '$_baseAddress/app/checkversion';
    //await authenticate();
    await getHeader();
    http.Response response = await http.get(url,headers: headers);
    var res = json.decode(response.body);
    int apiLngVersion = res['langVersion'];
    var langVersion = await getCurrentLangVersion();
    if (apiLngVersion > langVersion) {
      await getLanguages(apiLngVersion);
      return true;
    }
    // should update language
    return false;
  }

  Future<int> getApiLanguageVersion() async{
    final String url = '$_baseAddress/app/checkversion';
    http.Response response = await http.get(url,headers: headers);
    var res = json.decode(response.body);
    int apiLngVersion = res['langVersion'];
    return apiLngVersion;
  }

  Future<bool> checkLblVersion() async {
    final String url = '$_baseAddress/app/checkversion';
    http.Response response = await http.get(url,headers: headers);
    var res = json.decode(response.body);
    int apiLblVersion = res['lblVersion'];
    var lblVersion = await getCurrentLblVersion();
    if (apiLblVersion > lblVersion) return true;
    // should update labels
    return false;
  }

  Future<int> getApiLabelsVersion() async{
    final String url = '$_baseAddress/app/checkversion';
    //await authenticate();
    http.Response response = await http.get(url,headers: headers);
    var res = json.decode(response.body);
    int apiLblVersion = res['lblVersion'];
    return apiLblVersion;
  }

  fetchLabelsData() async {
    int lngVersion = 0;//await getCurrentLangVersion();
    String lngId = await getCurrentLngId();
    String apiUrl =
        '$_baseAddress/app/Labels/$lngVersion/$lngId/?fbclid=$_appId';
    final response = await http.get(apiUrl,headers: headers);
    String responseBody = response.body;

    saveLabelsDataAsPreferences(responseBody);
  }

  void saveLabelsDataAsPreferences(String responseBody) async {
    SharedPreferences prefs;
    Map<String, dynamic> parsedJson = json.decode(responseBody);
    LabelsApiModel labelsApiModel = LabelsApiModel.fromJson(parsedJson);

    prefs = await SharedPreferences.getInstance();
    await prefs.setString(PREFS_RESPONSE_BODY_KEY, responseBody);
    await prefs.setString(PREFS_VERSION_KEY, labelsApiModel.version.toString());

    final keys = labelsApiModel.labelCodes.keys.toList();
    final labels = labelsApiModel.labelCodes.values.toList();

    for(int i = 0; i < keys.length; i++){
      await prefs.setString(keys[i], labels[i]);
    }
    print('labels stored to preferences');
  }

  Future<int> getCurrentLangVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentVersion = (prefs.getInt('langVersion') ?? 0);
    return currentVersion;
  }

  updateLangVersion(int version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('langVersion', version);
  }

  Future<int> getCurrentLblVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentVersion = (prefs.getInt('lblVersion') ?? 0);
    return currentVersion;
  }

  updateLblVersion(int version) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('lblVersion', version);
  }

  storeUserToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    print('User Authentication Saved $token');
  }

  storeLanguage(String languageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageId', languageId);
    print('langue id saved');
  }

  Future<String> getCurrentLngId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String currentVersion = (prefs.getString('languageId') ?? 'AR-EG');
    return currentVersion;
  }

  getLanguages(int version) async {
    languages.clear();
    version = 0 ; // to be updated later
    final String url = '$_baseAddress/app/languages/$version';
    await getHeader();
    http.Response response = await http.get(url,headers: headers);
    var res = json.decode(response.body);
    var newLanguages = res['languages'];
    for (var l in newLanguages) {
      languages.add(Language(
        l['cultures'][0]['id'],
        l['version'],
        l['name'],
        l['rightToLeft'],
      ));
    }
    print(
        '${languages[0].id} - ${languages[0].name}  - ${languages[0].version} ');
  }
}
