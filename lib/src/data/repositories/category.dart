
import 'package:web_dashboard/src/models/category.dart';

/// Manipulates [Category] data.
abstract class CategoryRepository {
  Future<CategoryModel?> delete(String id);

  Future<CategoryModel?> get(String id);

  Future<CategoryModel> insert(CategoryModel category);

  Future<List<CategoryModel>> list();

  Future<CategoryModel> update(CategoryModel category, String id);

  Stream<List<CategoryModel>> subscribe();
}