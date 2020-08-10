class ClientMessageModel {
  int id;
  int version;
  String labelCode;

  ClientMessageModel(this.id, this.version, this.labelCode);

  ClientMessageModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        version = parsedJson['version'],
        labelCode = parsedJson['labelCode'];
}
