import '../../domain/entities/character.dart';

class CharacterModel extends Character {
  CharacterModel({
    required super.id,
    required super.name,
    super.height,
    super.mass,
    super.gender,
    super.homeworld,
    super.wiki,
    super.image,
    super.born,
    super.bornLocation,
    super.died,
    super.diedLocation,
    super.species,
    super.hairColor,
    super.eyeColor,
    super.skinColor,
    super.cybernetics,
    super.affiliations,
    super.masters,
    super.apprentices,
    super.formerAffiliations,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    List<String> _parseList(dynamic value) {
      if (value == null) return const [];
      if (value is List) return List<String>.from(value);
      if (value is String) return [value];
      return const [];
    }

    String? _parseString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is List) return value.join(', ');
      return value.toString();
    }

    int? _parseInt(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? _parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String,
      height: _parseDouble(json['height']),
      mass: _parseInt(json['mass']),
      gender: _parseString(json['gender']),
      homeworld: _parseString(json['homeworld']),
      wiki: _parseString(json['wiki']),
      image: _parseString(json['image']),
      born: _parseInt(json['born']),
      bornLocation: _parseString(json['bornLocation']),
      died: _parseInt(json['died']),
      diedLocation: _parseString(json['diedLocation']),
      species: _parseString(json['species']),
      hairColor: _parseString(json['hairColor']),
      eyeColor: _parseString(json['eyeColor']),
      skinColor: _parseString(json['skinColor']),
      cybernetics: _parseString(json['cybernetics']),
      affiliations: _parseList(json['affiliations']),
      masters: _parseList(json['masters']),
      apprentices: _parseList(json['apprentices']),
      formerAffiliations: _parseList(json['formerAffiliations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'height': height,
      'mass': mass,
      'gender': gender,
      'homeworld': homeworld,
      'wiki': wiki,
      'image': image,
      'born': born,
      'bornLocation': bornLocation,
      'died': died,
      'diedLocation': diedLocation,
      'species': species,
      'hairColor': hairColor,
      'eyeColor': eyeColor,
      'skinColor': skinColor,
      'cybernetics': cybernetics,
      'affiliations': affiliations,
      'masters': masters,
      'apprentices': apprentices,
      'formerAffiliations': formerAffiliations,
    };
  }
}
