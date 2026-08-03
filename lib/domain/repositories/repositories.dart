// §7 抽象 Repository 介面
// 實作放 data/repositories/

import 'package:brewlog/domain/entities/entities.dart';

abstract class BeanRepository {
  Future<List<Bean>> getAll();
  Future<Bean?> getById(String id);
  Future<void> save(Bean bean);
  Future<void> delete(String id);
}

abstract class BrewRepository {
  Future<List<Brew>> getAll();
  Future<Brew?> getById(String id);
  Future<void> save(Brew brew);
  Future<void> delete(String id);
}

abstract class RecipeRepository {
  Future<List<Recipe>> getAll();
  Future<Recipe?> getById(String id);
  Future<void> save(Recipe recipe);
  Future<void> delete(String id);
}

abstract class EquipmentRepository {
  Future<List<Equipment>> getAll();
  Future<void> save(Equipment equipment);
  Future<void> delete(String id);
}
