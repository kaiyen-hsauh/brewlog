// §8.1 application layer — Riverpod providers
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brewlog/core/constants/grinders.dart';
import 'package:brewlog/core/constants/brew_methods.dart';
import 'package:brewlog/data/repositories/hive_repositories.dart';
import 'package:brewlog/domain/entities/entities.dart';
import 'package:brewlog/domain/repositories/repositories.dart';

// Singleton repositories
final beanRepoProvider = Provider<BeanRepository>((ref) => beanRepository);
final brewRepoProvider = Provider<BrewRepository>((ref) => brewRepository);
final recipeRepoProvider = Provider<RecipeRepository>((ref) => recipeRepository);
final equipmentRepoProvider = Provider<EquipmentRepository>((ref) => equipmentRepository);

// §6.1 / §6.4 catalogs
final brewMethodCatalogProvider = Provider<BrewMethodCatalog>(
    (ref) => BrewMethodCatalog.instance);
final grinderCatalogProvider = Provider<GrinderCatalog>((ref) => GrinderCatalog.instance);

// ListProviders — refresh via ref.invalidate 或寫入後自己 invalidate
class BeansNotifier extends AsyncNotifier<List<Bean>> {
  @override
  Future<List<Bean>> build() async {
    final repo = ref.read(beanRepoProvider);
    final list = await repo.getAll();
    list.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  Future<void> save(Bean bean) async {
    await ref.read(beanRepoProvider).save(bean);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String id) async {
    await ref.read(beanRepoProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }
}

final beansProvider = AsyncNotifierProvider<BeansNotifier, List<Bean>>(
    BeansNotifier.new);

class BrewsNotifier extends AsyncNotifier<List<Brew>> {
  @override
  Future<List<Brew>> build() async {
    final repo = ref.read(brewRepoProvider);
    final list = await repo.getAll();
    list.sort((a, b) => b.brewedAt.compareTo(a.brewedAt));
    return list;
  }

  Future<void> save(Brew brew) async {
    await ref.read(brewRepoProvider).save(brew);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String id) async {
    await ref.read(brewRepoProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }
}

final brewsProvider = AsyncNotifierProvider<BrewsNotifier, List<Brew>>(
    BrewsNotifier.new);

class RecipesNotifier extends AsyncNotifier<List<Recipe>> {
  @override
  Future<List<Recipe>> build() async {
    final repo = ref.read(recipeRepoProvider);
    final list = await repo.getAll();
    list.sort((a, b) {
      if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  Future<void> save(Recipe recipe) async {
    await ref.read(recipeRepoProvider).save(recipe);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String id) async {
    await ref.read(recipeRepoProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }
}

final recipesProvider = AsyncNotifierProvider<RecipesNotifier, List<Recipe>>(
    RecipesNotifier.new);

class EquipmentNotifier extends AsyncNotifier<List<Equipment>> {
  @override
  Future<List<Equipment>> build() async {
    return ref.read(equipmentRepoProvider).getAll();
  }

  Future<void> save(Equipment e) async {
    await ref.read(equipmentRepoProvider).save(e);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String id) async {
    await ref.read(equipmentRepoProvider).delete(id);
    ref.invalidateSelf();
    await future;
  }
}

final equipmentProvider = AsyncNotifierProvider<EquipmentNotifier, List<Equipment>>(
    EquipmentNotifier.new);
