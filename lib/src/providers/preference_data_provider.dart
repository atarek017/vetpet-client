import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/service_model.dart';
import '../models/labels_api_model.dart';
import '../models/client_message_model.dart';
import 'dart:convert';
import '../mixins/preferences_keys_mixin.dart';

class PreferenceDataProvider extends Object with PreferencesKeysMixin {

  Future<String> getServiceLabel(int serviceId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LabelsApiModel labelsApiModel = LabelsApiModel.fromJson(
        json.decode(prefs.getString(PREFS_RESPONSE_BODY_KEY)));
    ServiceModel service =
        labelsApiModel.svcs.firstWhere((data) => data.id == serviceId);
    if (service != null) {
      String labelCode = service.labelCode;
      return prefs.getString(labelCode);
    }
    return null;
  }



  Future<List<ServiceModel>> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LabelsApiModel labelsApiModel = LabelsApiModel.fromJson(
        json.decode(prefs.getString(PREFS_RESPONSE_BODY_KEY)));

    ServiceModel service;
    List<ServiceModel> servicesLabels = [];

    for (service in labelsApiModel.svcs) {
      if (prefs.getString(service.labelCode) != null) {
        servicesLabels.add(ServiceModel(
            service.id,
            prefs.getString(service.labelCode),
            service.svcTypId,
            service.imgUrl));
      } else {
        servicesLabels.add(ServiceModel(service.id,
            service.labelCode.toString(), service.svcTypId, service.imgUrl));

        print(
            "{ ${service.id},  ${service.labelCode.toString()}:  , ${service.svcTypId}, ${service.imgUrl} } ");
      }
    }

    return servicesLabels;
  }

  Future<String> getMessageFromCode(context, msgCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LabelsApiModel labelsApiModel = LabelsApiModel.fromJson(
        json.decode(prefs.getString(PREFS_RESPONSE_BODY_KEY)));
    ClientMessageModel clientMsg = labelsApiModel.clientMsgs
        .firstWhere((data) => data.labelCode == msgCode);
    if (clientMsg != null) {
      String messageKey = clientMsg.labelCode;
      return prefs.getString(messageKey);
    }
    return null;
  }

  Future<String> getLabelFromKey(String labelKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String label=prefs.getString(labelKey);
    if (label==null || label=='' || label==' ' || label.length==0){
      return labelKey;
    }
    return label;
  }
}
