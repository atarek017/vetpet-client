class SizeModel {
  int id;
  String labelCode;
  int petTypId;
  int order;
  String imgUrl;

  SizeModel(this.id, this.labelCode, this.petTypId, this.order, this.imgUrl);

  SizeModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        labelCode = parsedJson['labelCode'],
        petTypId = parsedJson['petTypId'],
        order = parsedJson['order'],
        imgUrl = parsedJson['imgUrl'];
}
