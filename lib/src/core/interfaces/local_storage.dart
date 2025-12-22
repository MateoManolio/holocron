abstract interface class ILocalStorage {
  /// Initializes the storage service.
  Future<void> init();

  /// Retrieves a value from the specified box.
  Future<T?> getValue<T>(String boxName, String key);

  /// Stores a value in the specified box.
  Future<void> setValue<T>(String boxName, String key, T value);

  /// Deletes a value from the specified box.
  Future<void> deleteValue(String boxName, String key);

  /// Clears all values from the specified box.
  Future<void> clearBox(String boxName);

  /// Closes the storage service.
  Future<void> close();
}

