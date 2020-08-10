import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/models/pet.dart';
import '../models/pets.dart';

class PetProvider {
  String userId = '';

  Future<bool> addPet(
      String name, String specie, int petType, String petSize) async {
    await _getUserId();
    print(userId);

    var url = "https://capi-dev.vetwork.co/user/newpet";

    var body = json.encode({
      "userid": userId.toString(),
      "petname": name,
      "pettypeid": petType,
      "petsizeid": petSize,
    });

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);

    final responseJson = json.decode(response.body);
    print(responseJson);

    if (responseJson['success'] == true) {
      _savePetId(responseJson['paras']['id']);
      _seveType(petType);
      return true;
    }

    return false;
  }

  Future<List<Pet>> getPets() async {
    List<Pet> pets = [];
    await _getUserId();

    if (userId == '' || userId == null || userId.length == 0) {
      return pets;
    }
    var url = "https://capi-dev.vetwork.co/user/pets";

    var body = json.encode({
      "userid": userId.toString(),
    });

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    print('VetPet Request Pets $body');

    final response = await http.post(url, body: body, headers: headers);
    final responseJson = json.decode(response.body);
    print('VetPet Response Pets $body');

    print(responseJson);

    if (responseJson["success"] == true) {
      List<dynamic> getPets = responseJson['paras']['pets'];
      pets = getPets.map((pet) => Pet.fromJson(pet)).toList();
    }

    return pets;
  }

  Future<bool> updatePet(int petId, String name) async {
    await _getUserId();

    Map<String, dynamic> requestBody = {
      "userid": userId,
      "petid": petId,
      "petname": name,
      "petsizeid": "3",
    };

    http.Response response = await http.put(
      'https://capi-dev.vetwork.co/user/updatepet',
      body: requestBody,
      headers: {"Content-Type": "application/json"},
    );

    print(response.body.toString());
    var res = json.decode(response.body);

    if (res['success'] == true) {
      return true;
    }
    return false;
  }

  _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userID");
  }

  _savePetId(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("petID", value);
    print(value);
  }

  _seveType(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("petType", value);
  }

  Future<List<Pets>> fetchPets() async {
    List<Pets> pets;
    await _getUserId();

    var url = "https://capi-dev.vetwork.co/user/pets";

    var body = json.encode({
      "userid": userId.toString(),
    });

    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, body: body, headers: headers);
    final responseJson = json.decode(response.body);

    print(responseJson);

    if (responseJson["success"] == true) {
      List<dynamic> getPets = responseJson['paras']['pets'];
      pets = getPets.map((pet) => Pets.fromJson(pet)).toList();
    }

    return pets;
  }
}
