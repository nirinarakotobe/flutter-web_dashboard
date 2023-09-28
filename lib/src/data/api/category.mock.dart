import 'dart:async';

import 'package:uuid/uuid.dart' as uuid;

import 'package:web_dashboard/src/data/repositories/category.dart';
import 'package:web_dashboard/src/models/category.dart';

class CategoryMockData implements CategoryRepository {
  final Map<String, CategoryModel> _storage = {};
  final StreamController<List<CategoryModel>> _streamController =
      StreamController<List<CategoryModel>>.broadcast();

  @override
  Future<CategoryModel?> delete(String id) async {
    var removed = _storage.remove(id);
    _emit();
    return removed;
  }

  @override
  Future<CategoryModel?> get(String id) async {
    return _storage[id];
  }

  @override
  Future<CategoryModel> insert(CategoryModel category) async {
    var id = const uuid.Uuid().v4();
    var newCategory = CategoryModel(category.name)..id = id;
    _storage[id] = newCategory;
    _emit();
    return newCategory;
  }

  @override
  Future<List<CategoryModel>> list() async {
    return _storage.values.toList();
  }

  @override
  Future<CategoryModel> update(CategoryModel category, String id) async {
    _storage[id] = category;
    _emit();
    return category..id = id;
  }

  @override
  Stream<List<CategoryModel>> subscribe() => _streamController.stream;

  void _emit() {
    _streamController.add(_storage.values.toList());
  }
}
