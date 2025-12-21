class Character {
  final String id;
  final String name;
  final String imagePath;
  final String species;
  final String gender;
  final String homeworld;
  final String birthYear;
  final int? height;
  final String? eyeColor;
  final String? mass;
  final List<String> affiliations;

  Character({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.species,
    required this.gender,
    required this.homeworld,
    required this.birthYear,
    required this.height,
    required this.eyeColor,
    required this.mass,
    required this.affiliations,
  });
}
