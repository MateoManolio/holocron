class SortConstants {
  // Character sort options
  static const String relevance = 'Relevance';
  static const String name = 'Name';
  static const String newest = 'Newest';
  static const String oldest = 'Oldest';

  static const List<String> characterOptions = [
    relevance,
    name,
    newest,
    oldest,
  ];

  // Favorites sort options
  static const String defaultSort = 'Default';
  static const String nameAZ = 'Name A-Z';
  static const String nameZA = 'Name Z-A';

  static const List<String> favoritesOptions = [
    defaultSort,
    nameAZ,
    nameZA,
    newest,
    oldest,
  ];
}
