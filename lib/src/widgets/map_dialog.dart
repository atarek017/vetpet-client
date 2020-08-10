import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:geocoder/geocoder.dart';

import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:vetwork_app/src/mixins/preferences_keys_mixin.dart';
import 'package:vetwork_app/src/providers/address_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';
import 'package:vetwork_app/src/screens/home.dart';
import '../LocalizaionConstants.dart';

const kGoogleApiKey = "AIzaSyAWdJUdZD75aDBqMMAT3RITwbjqMAs5WVw";

class MapDialog with PreferencesKeysMixin {
  GoogleMapController mapController;
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  LatLng _center = LatLng(30.044281, 31.340002);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  AddressProvider _addressProvider = new AddressProvider();

  int locationSaved = -1;

  MapDialog(this.scaffoldKey);
  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();

  Future<bool> displayMapDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        return Container(
          margin:
              EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),
          width: screenWidth,
          height: screenHeight * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: Colors.white,
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 15.0,
                top: 14.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                  ),
                ),
              ),
              Positioned(
                top: 15.0,
                left: screenWidth / 5.5,
                child: FutureBuilder(
                  future: prefsDataProvider
                      .getLabelFromKey(Label_SET_YOUR_LOCATION),
                  builder: (context, snapshot) {
                    if (snapshot.hasData)
                      return Text(
                        snapshot.data,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: 'Monteserrat',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[600],
                          decoration: TextDecoration.none,
                        ),
                      );
                    return Container();
                  },
                ),
              ),
              Positioned(
                child: Container(
                  margin: EdgeInsets.only(top: 45.0, left: 10.0, right: 10.0),
                  height: screenHeight * 0.72,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      options: GoogleMapOptions(
                        trackCameraPosition: true,
                        myLocationEnabled: true,
                        cameraPosition: const CameraPosition(
                          target: LatLng(0.0, 0.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 45,
                left: 10,
                child: Container(),
              ),
              buildSubmitButton(screenWidth, screenHeight, context)
            ],
          ),
        );
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    refresh();
  }

  void refresh() async {
    final center = await getUserLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: center == null ? LatLng(0, 0) : center, zoom: 15.0)));
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);
      mapController.addMarker(MarkerOptions(
        position: center,
      ));
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  Future<void> _handlePressButton(context) async {
    try {
      final center = await getUserLocation();
      Prediction p = await PlacesAutocomplete.show(
          context: context,
          strictbounds: center == null ? false : true,
          apiKey: kGoogleApiKey,
          onError: onError,
          mode: Mode.fullscreen,
          language: "en",
          location: center == null
              ? null
              : Location(center.latitude, center.longitude),
          radius: center == null ? null : 10000);
// from here
      PlacesDetailsResponse place =
          await _places.getDetailsByPlaceId(p.placeId);
      print(
          'place details ${place.result.geometry.location.lat} - ${place.result.geometry.location.lng}');
      var newLocation = LatLng(place.result.geometry.location.lat,
          place.result.geometry.location.lng);
      mapController.clearMarkers();
      mapController.moveCamera(CameraUpdate.newLatLng(newLocation));
      mapController.addMarker(MarkerOptions(
        position: newLocation,
      ));
// to here is changes to be tested

    } catch (e) {
      return;
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Widget buildSubmitButton(double _width, double _height, context) {
    return Positioned(
      left: _width * 0.06,
      bottom: 19.0,
      height: 40,
      width: _width * 0.83,
      child: MaterialButton(
        padding: EdgeInsets.all(0.0),
        onPressed: () async {
          _center = mapController.cameraPosition.target;
          String location =
              _center.longitude.toString() + "," + _center.latitude.toString();

          var addresses = await Geocoder.local.findAddressesFromCoordinates(
              Coordinates(_center.latitude, _center.longitude));
            
          var first = addresses.first;

          String result = await _addressProvider.addAddress(first.addressLine,
              first.featureName, first.adminArea, first.countryCode, location);
          SharedPreferences shared = await SharedPreferences.getInstance();
          shared.setString('current_addressLine', first.addressLine);

          if (result == '111') {
            print("request visit has been sent");
          } else {
            Navigator.pop(context);
            _showDialog(context);
          }
          Navigator.pop(context);
        },
        child: Container(
          width: _width * 0.9,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.blue[500],
                Colors.blue[900],
              ],
            ),
          ),
          child: Center(
            child: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey(Label_SAVE_MY_LOCATION),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  );
                return Container();
              },
            ),
          ),
        ),
      ),
    );
  }


  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Active_request"),
          content:  Text("active_request"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child:  Text("OK"),
              onPressed: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (BuildContext context) => Home()));
              },
            ),
          ],
        );
      },
    );
  }
}
