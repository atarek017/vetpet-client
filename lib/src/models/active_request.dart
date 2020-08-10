import 'package:vetwork_app/src/models/address.dart';

class ActiveRequests {
  final int id;
  final int statusId;
  final String provNo;
  final String date;
  final Address address ;
  ActiveRequests(this.id, this.statusId, this.provNo,this.date,this.address);

  ActiveRequests.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        statusId = parsedJson['statusId'],
        provNo = parsedJson['provNo'],
        date = parsedJson['visitTime'],
        address = Address.fromJson(parsedJson['address']);
}
