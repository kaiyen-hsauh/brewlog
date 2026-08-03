// §8.2 Hive 實作 Repository — 手寫 fromJson/toJson(不依賴 build_runner §8.2 MUST NOT)
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/domain/repositories/repositories.dart';
import 'package:brewlog/data/datasources/local/hive_setup.dart';

class _HiveBeanRepository implements BeanRepository {
  Box get _box => Hive.box(HiveBoxes.beans);
  String _k(String id) => id;

  @override
  Future<List<Bean>> getAll() async {
    return _box.values
        .map((e) => Bean.fromJson((jsonDecode(e as String) as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Bean?> getById(String id) async {
    final raw = _box.get(_k(id));
    if (raw == null) return null;
    return Bean.fromJson((jsonDecode(raw as String) as Map).cast<String, dynamic>());
  }

  @override
  Future<void> save(Bean bean) async {
    await _box.put(_k(bean.id), jsonEncode(bean.toJson()));
  }

  @override
  Future<void> delete(String id) async => _box.delete(_k(id));
}

class _HiveBrewRepository implements BrewRepository {
  Box get _box => Hive.box(HiveBoxes.brews);
  @override
  Future<List<Brew>> getAll() async {
    return _box.values
        .map((e) => Brew.fromJson((jsonDecode(e as String) as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Brew?> getById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    return Brew.fromJson((jsonDecode(raw as String) as Map).cast<String, dynamic>());
  }

  @override
  Future<void> save(Brew brew) async => _box.put(brew.id, jsonEncode(brew.toJson()));
  @override
  Future<void> delete(String id) async => _box.delete(id);
}

class _HiveRecipeRepository implements RecipeRepository {
  Box get _box => Hive.box(HiveBoxes.recipes);
  @override
  Future<List<Recipe>> getAll() async {
    return _box.values
        .map((e) => Recipe.fromJson((jsonDecode(e as String) as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<Recipe?> getById(String id) async {
    final raw = _box.get(id);
    if (raw == null) return null;
    return Recipe.fromJson((jsonDecode(raw as String) as Map).cast<String, dynamic>());
  }

  @override
  Future<void> save(Recipe recipe) async => _box.put(recipe.id, jsonEncode(recipe.toJson()));
  @override
  Future<void> delete(String id) async => _box.delete(id);
}

class _HiveEquipmentRepository implements EquipmentRepository {
  Box get _box => Hive.box(HiveBoxes.equipment);
  @override
  Future<List<Equipment>> getAll() async {
    return _box.values
        .map((e) => Equipment.fromJson((jsonDecode(e as String) as Map).cast<String, dynamic>()))
        .toList();
  }

  @override
  Future<void> save(Equipment equipment) async =>
      _box.put(equipment.id, jsonEncode(equipment.toJson()));
  @override
  Future<void> delete(String id) async => _box.delete(id);
}

// Singleton instances
final beanRepository = _HiveBeanRepository();
final brewRepository = _HiveBrewRepository();
final recipeRepository = _HiveRecipeRepository();
final equipmentRepository = _HiveEquipmentRepository();
