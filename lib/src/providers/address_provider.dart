import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/models/address.dart';
import 'globals.dart' as globals;

class AddressProvider {
  String userId = '';
  int addressid;
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader: globals.authToken,
    "Content-Type": "application/json"
  };

  getHeader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var auth = prefs.getString('authToken');
    headers[HttpHeaders.authorizationHeader] = 'Bearer $auth';
  }

  Future<List<Address>> getAddress() async {
    await getHeader();
    List<Address> addresses = [];

    await _getUserId();
    print("userID : $userId");
    var url = "https://capi.vetwork.co/user/addresses";
    var body = json.encode({
      "userid": userId.toString(),
    });

    print('VetPet Request:$url $body');
    final response = await http.post(url, body: body, headers: headers);

    final responseJson = json.decode(response.body);
    print('VetPet Request:$responseJson');

    print(responseJson.toString());

    if (responseJson == "900") {
      return null;
    }

    if (responseJson["success"] == true) {
      List<dynamic> getAdd = responseJson['paras']['addresses'];
      addresses = getAdd.map((address) => Address.fromJson(address)).toList();
    }

    return addresses;
  }

  Future<String> addAddress(String line1, String city, String state,
      String countryIso, String location) async {
    await _getUserId();
    await getHeader();

    print("UserID:- $userId");

    Map<String, dynamic> requestBody = {
      "userid": userId,
      "addressLine1": line1,
      "addressLine2": 456,
      "city": city,
      "state": state,
      "countryISO": "EG",
      "isDefault": true,
      "location": location,
    };

    print(requestBody.toString());

    http.Response response = await http.post(
        "https://capi.vetwork.co/user/newaddress",
        body: json.encode(requestBody),
        headers: headers);

    print(response.body.toString());

    var res = json.decode(response.body);

    print(res.toString());
    if (response.statusCode != 200) {
      return res.toString();
    }
    if (res == 900) {
      return '900';
    }

    if (res['success'] == true) {
      setUserAddressId(res['paras']['id']);
      print(res['paras']['id']);
      return '111';
    }
    return res['code'];
  }

  Future<bool> updateAddress(
      addressLine1, addressLine2, city, state, countryISO, isDefault) async {
    await _getUserId();
    await _getUserAddressId();

    print("UserID");
    print(userId);

    Map<String, dynamic> requestBody = {
      "userid": userId,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "city": city,
      "state": state,
      "countryISO": countryISO,
      "isDefault": isDefault,
      "addressid": addressid,
    };

    print(requestBody.toString());

    http.Response response = await http.put(
        "https://capi.vetwork.co/user/updateaddress",
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"});

    var res = json.decode(response.body);
    print(res.toString());

    if (res['success'] == true) {
      return true;
    }
    return false;
  }

  Future<bool> deleteAddress(int addressId) async {
    await _getUserId();
    await _getUserAddressId();

    print(userId);
    print(addressId);

    Map<String, dynamic> address = {
      "userid": userId,
      "addressid": addressId,
    };

    await http.post(
        "https://capi.vetwork.co/user/deleteaddress",
        body: json.encode(address),
        headers: {"Content-Type": "application/json"},
    ).then((onValue){
      print(onValue.body.toString());

      if(addressId==addressid){
        _deleteAddressPreferences();
      }
    });

  }

  Future<Null> deleteAllAddresses() async {
    final String _baseAddress = 'https://capi.vetwork.co/';
    await _getUserId();
    print(userId);
    Map<String, String> requestBody = {
      "userid": userId,
    };
    final String url = '$_baseAddress/user/addresses';
    http.Response response = await http.post(url,
        body: json.encode(requestBody),
        headers: {"Content-Type": "application/json"});
    var addresses = json.decode(response.body);
    List<int> addressIDs = [];
    for (var address in addresses['paras']['addresses']) {
      addressIDs.add(address['id']);
    }
    print('$addressIDs');
    String deleteUrl = '$_baseAddress/user/deleteaddress';
    for (int i in addressIDs) {
      Map<String, dynamic> deleteRequestBody = {
        "userid": userId,
        "addressid": i
      };
      http.Response res = await http.post(deleteUrl,
          body: json.encode(deleteRequestBody),
          headers: {"Content-Type": "application/json"});
      print('address #$i is deleted: ${res.body}');
    }
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userID");
  }

  setUserAddressId(id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("adressid", id);
  }

  _getUserAddressId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    addressid = prefs.getInt("adressid");
  }

  _deleteAddressPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("adressid", null);
  }
}
