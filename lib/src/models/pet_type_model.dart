class PetTypeModel {
  int id;
  String labelCode;
  String imgUrl;

  PetTypeModel(this.id, this.labelCode, this.imgUrl);

  PetTypeModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        labelCode = parsedJson['labelCode'],
        imgUrl = parsedJson['imgUrl'];
}
