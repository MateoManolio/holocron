class Character {
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

  Character({
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
}

