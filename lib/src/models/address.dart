class Address {
  final int id;
  final bool isDefault;
  final String line1;
  final String line2;
  final String state;
  final String city;
  final String postalcode;
  final String countryIso;
  final String location;


  Address(this.id, this.isDefault, this.line1, this.line2, this.state,
      this.city, this.postalcode, this.countryIso, this.location);

  Address.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'],
        isDefault = parsedJson['isDefault'],
        line1 = parsedJson['line1'],
        line2 = parsedJson['line2'],
        state = parsedJson['state'],
        city = parsedJson['city'],
        postalcode = parsedJson['postalcode'],
        countryIso = parsedJson['countryIso'],
        location = parsedJson['location'];

}
