import 'package:scoped_model/scoped_model.dart';

import '../enums/gender.dart';

class PetModel extends Model {
  Map<String, dynamic> _petData = {
    'image': '',
    'name': '',
    'species': '',
    'size': '',
    'breed': '',
    'gender': 0,
    'neutered': null,
    'insured': null,
    'birthdate': '',
    'behaviour': '',
    'vaccinedate': '',
    'description': ''
  };

  Map<String, dynamic> get petData => _petData;

// Image
  setImage(String image) {
    _petData['image'] = image;
    notifyListeners();
  }

  String getImage() => _petData['image'];

// name
  setName(String name) {
    _petData['name'] = name;
  }

  String getName() => _petData['name'];

// species
  setSpecies(String species) {
    _petData['species'] = species;
  }

  String getSpecies() => _petData['species'];

// size
  setSize(String size) {
    _petData['size'] = size;
  }

  String getSize() => _petData['size'];

// breed
  setBreed(String breed) {
    _petData['breed'] = breed;
  }

  String getBreed() => _petData['breed'];

//gender
  setGender(int gender) {
    _petData['gender'] = gender;
  }

  int getGender() => _petData['gender'];

//neutered
  setNeutered(bool neutered) {
    _petData['neutered'] = neutered;
  }

  bool getNeutered() => _petData['neutered'];

  //insured
  setInsured(bool insured) {
    _petData['insured'] = insured;
  }

  bool getInsured() => _petData['insured'];

  // birth date
  setBirthDate(String birthDate) {
    _petData['birthdate'] = birthDate;
  }

  String getBirthDate() => _petData['birthdate'];

  // behaviour
  setBehaviour(String behaviour) {
    _petData['behaviour'] = behaviour;
  }

  String getBehaviour() => _petData['behaviour'];

  // vaccine date
  setVaccineDate(String vaccineDate) {
    _petData['vaccinedate'] = vaccineDate;
  }

  String getVaccineDate() => _petData['vaccinedate'];

  // description
  setDescription(String description) {
    _petData['description'] = description;
  }

  String getDescription() => _petData['description'];
}
