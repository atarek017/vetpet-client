class Pets {
  final int id;
  final int petTypId;
  final int sizeId;
  final String name;
  final String imgUrl;

  Pets(this.id, this.petTypId, this.sizeId, this.name, this.imgUrl);

  Pets.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        petTypId = parsedJson['petTypId'],
        sizeId = parsedJson['sizeId'],
        name = parsedJson['name'],
        imgUrl = parsedJson['imgUrl'] ??
            'https://images.spot.im/v1/production/phj6czto7p709vbh7kel';
}
