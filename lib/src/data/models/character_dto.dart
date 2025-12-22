class CharacterDto {
  final int id;
  final String name;
  final double? height;
  final int? mass;
  final String? gender;
  final String? homeworld;
  final String? wiki;
  final String? image;
  final int? born;
  final String? bornLocation;
  final int? died;
  final String? diedLocation;
  final String? species;
  final String? hairColor;
  final String? eyeColor;
  final String? skinColor;
  final String? cybernetics;
  final List<String> affiliations;
  final List<String> masters;
  final List<String> apprentices;
  final List<String> formerAffiliations;

  CharacterDto({
    required this.id,
    required this.name,
    this.height,
    this.mass,
    this.gender,
    this.homeworld,
    this.wiki,
    this.image,
    this.born,
    this.bornLocation,
    this.died,
    this.diedLocation,
    this.species,
    this.hairColor,
    this.eyeColor,
    this.skinColor,
    this.cybernetics,
    this.affiliations = const [],
    this.masters = const [],
    this.apprentices = const [],
    this.formerAffiliations = const [],
  });

  factory CharacterDto.fromJson(Map<String, dynamic> json) {
    List<String> parseList(dynamic value) {
      if (value == null) return const [];
      if (value is List) return List<String>.from(value);
      if (value is String) return [value];
      return const [];
    }

    String? parseString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value;
      if (value is List) return value.join(', ');
      return value.toString();
    }

    int? parseInt(dynamic value) {
      if (value is num) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    double? parseDouble(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return CharacterDto(
      id: json['id'] as int,
      name: json['name'] as String,
      height: parseDouble(json['height']),
      mass: parseInt(json['mass']),
      gender: parseString(json['gender']),
      homeworld: parseString(json['homeworld']),
      wiki: parseString(json['wiki']),
      image: parseString(json['image']),
      born: parseInt(json['born']),
      bornLocation: parseString(json['bornLocation']),
      died: parseInt(json['died']),
      diedLocation: parseString(json['diedLocation']),
      species: parseString(json['species']),
      hairColor: parseString(json['hairColor']),
      eyeColor: parseString(json['eyeColor']),
      skinColor: parseString(json['skinColor']),
      cybernetics: parseString(json['cybernetics']),
      affiliations: parseList(json['affiliations']),
      masters: parseList(json['masters']),
      apprentices: parseList(json['apprentices']),
      formerAffiliations: parseList(json['formerAffiliations']),
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

