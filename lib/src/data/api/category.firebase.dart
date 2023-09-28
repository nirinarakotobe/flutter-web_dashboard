import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/data/repositories/category.dart';
import 'package:web_dashboard/src/models/category.dart';

class CategoryFirebaseData implements CategoryRepository {
  final FirebaseFirestore firestore;
  final String userId;
  final CollectionReference<Map<String, dynamic>> _categoriesRef;

  CategoryFirebaseData(this.firestore, this.userId)
      : _categoriesRef = firestore.collection('users/$userId/categories');

  @override
  Stream<List<CategoryModel>> subscribe() {
    var snapshots = _categoriesRef.snapshots();
    var result = snapshots.map<List<CategoryModel>>((querySnapshot) {
      return querySnapshot.docs.map<CategoryModel>((snapshot) {
        return CategoryModel.fromJson(snapshot.data())..id = snapshot.id;
      }).toList();
    });

    return result;
  }

  @override
  Future<CategoryModel> delete(String id) async {
    var document = _categoriesRef.doc(id);
    var categories = await get(document.id);

    await document.delete();

    return categories;
  }

  @override
  Future<CategoryModel> get(String id) async {
    var document = _categoriesRef.doc(id);
    var snapshot = await document.get();
    return CategoryModel.fromJson(snapshot.data()!)..id = snapshot.id;
  }

  @override
  Future<CategoryModel> insert(CategoryModel category) async {
    var document = await _categoriesRef.add(category.toJson());
    return await get(document.id);
  }

  @override
  Future<List<CategoryModel>> list() async {
    var querySnapshot = await _categoriesRef.get();
    var categories = querySnapshot.docs
        .map((doc) => CategoryModel.fromJson(doc.data())..id = doc.id)
        .toList();

    return categories;
  }

  @override
  Future<CategoryModel> update(CategoryModel category, String id) async {
    var document = _categoriesRef.doc(id);
    await document.update(category.toJson());
    var snapshot = await document.get();
    return CategoryModel.fromJson(snapshot.data()!)..id = snapshot.id;
  }
}
