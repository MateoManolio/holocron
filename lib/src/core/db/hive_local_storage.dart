import 'package:hive_ce_flutter/hive_flutter.dart';
import '../interfaces/local_storage.dart';

class HiveLocalStorage implements ILocalStorage {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<T?> getValue<T>(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    return box.get(key) as T?;
  }

  @override
  Future<void> setValue<T>(String boxName, String key, T value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  @override
  Future<void> deleteValue(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clearBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    await box.clear();
  }

  @override
  Future<void> close() async {
    await Hive.close();
  }
}

