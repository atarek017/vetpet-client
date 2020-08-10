class ServiceModel {
  int id;
  String labelCode;
  int svcTypId;
  String imgUrl;

  ServiceModel(this.id, this.labelCode, this.svcTypId, this.imgUrl);

  ServiceModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        labelCode = parsedJson['labelCode'],
        svcTypId = parsedJson['svcTypId'],
        imgUrl = parsedJson['imgUrl'];
}
