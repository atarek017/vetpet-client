class ServiceTypeModel {
  int id;
  String labelCode;
  String imgUrl;

  ServiceTypeModel(this.id, this.labelCode, this.imgUrl);

  ServiceTypeModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        labelCode = parsedJson['labelCode'],
        imgUrl = parsedJson['imgUrl'];
}
