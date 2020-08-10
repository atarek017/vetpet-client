import 'pet_type_model.dart';
import 'service_model.dart';
import 'client_message_model.dart';
import 'service_type_model.dart';
import 'size_model.dart';

class LabelsApiModel {
  int version;
  List<PetTypeModel> petTyps;
  List<ServiceTypeModel> svcTyps;
  List<ClientMessageModel> clientMsgs;
  List<ServiceModel> svcs;
  List<SizeModel> sizes;
  Map<String, dynamic> labelCodes;

  LabelsApiModel(this.version, this.petTyps, this.svcTyps, this.clientMsgs,
      this.svcs, this.sizes, this.labelCodes);

  LabelsApiModel.fromJson(Map<String, dynamic> parsedJson) {

    version = parsedJson['version'];

    List<dynamic> tempList = parsedJson['petTyps'];
    petTyps = tempList
        .map((petType) => PetTypeModel.fromJson(petType))
        .toList();

    tempList = parsedJson['svcTyps'];
    svcTyps = tempList
        .map((serviceType) => ServiceTypeModel.fromJson(serviceType))
        .toList();

    tempList = parsedJson['clientMsgs'];
    clientMsgs = tempList
        .map((clientMessage) => ClientMessageModel.fromJson(clientMessage))
        .toList();

    tempList = parsedJson['svcs'];
    svcs = tempList
        .map((service) => ServiceModel.fromJson(service))
        .toList();

    tempList = parsedJson['sizes'];
    sizes = tempList.map((size) => SizeModel.fromJson(size)).toList();

    labelCodes = parsedJson['labelCodes'];
  }
}

class LabelCodesModel {
  String another;
  String bigsize_1;
  String cancel;
  String checkup;
  String deworming;
  String evacuation;
  String help;
  String home;
  String msg_111;
  String msg_900;
  String msg_910;
  String msg_911;
  String msg_999;
  String offer;
  String pettype_1;
  String pettype_2;
  String svctype_1;
  String svctype_2;
  String username;
  String vaccine;
  String welcome;
  String xray;

  String abscess_cleaning;
  String add_location ;
  String add_new_address ;
  String back ;
  String choose_services ;
  String choose_species ;
  String confirm ;
  String finish_your_request ;
  String location ;
  String mobile ;



  LabelCodesModel(
      this.another,
      this.bigsize_1,
      this.cancel,
      this.checkup,
      this.deworming,
      this.evacuation,
      this.help,
      this.home,
      this.msg_111,
      this.msg_900,
      this.msg_910,
      this.msg_911,
      this.msg_999,
      this.offer,
      this.pettype_1,
      this.pettype_2,
      this.svctype_1,
      this.svctype_2,
      this.username,
      this.vaccine,
      this.welcome,
      this.xray);

  LabelCodesModel.fromJson(Map<String, dynamic> parsedJson)
      : another = parsedJson['another'],
        bigsize_1 = parsedJson['bigsize_1'],
        cancel = parsedJson['cancel'],
        checkup = parsedJson['checkup'],
        deworming = parsedJson['deworming'],
        evacuation = parsedJson['evacuation'],
        help = parsedJson['help'],
        home = parsedJson['home'],
        msg_111 = parsedJson['msg_111'],
        msg_900 = parsedJson['msg_900'],
        msg_910 = parsedJson['msg_910'],
        msg_911 = parsedJson['msg_911'],
        msg_999 = parsedJson['msg_999'],
        offer = parsedJson['offer'],
        pettype_1 = parsedJson['pettype_1'],
        pettype_2 = parsedJson['pettype_2'],
        svctype_1 = parsedJson['svctype_1'],
        svctype_2 = parsedJson['svctype_2'],
        username = parsedJson['username'],
        vaccine = parsedJson['vaccine'],
        welcome = parsedJson['welcome'],
        xray = parsedJson['xray'];
}
