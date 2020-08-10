class Pet {
  final int id;
  final int petTypId;
  final int sizeId;
  final String name;
  final String imgUrl;

  Pet(this.id, this.petTypId, this.sizeId, this.name, this.imgUrl);

  Pet.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        petTypId = parsedJson['petTypId'],
        sizeId = parsedJson['sizeId'],
        name = parsedJson['name'],
        imgUrl = parsedJson['imgUrl'];
}
