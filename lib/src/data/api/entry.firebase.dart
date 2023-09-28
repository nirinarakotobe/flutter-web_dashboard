import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/data/repositories/entry.dart';
import 'package:web_dashboard/src/models/entry.dart';

class EntryFirebaseData implements EntryRepository {
  final FirebaseFirestore firestore;
  final String userId;
  final CollectionReference<Map<String, dynamic>> _categoriesRef;

  EntryFirebaseData(this.firestore, this.userId)
      : _categoriesRef = firestore.collection('users/$userId/categories');

  @override
  Stream<List<EntryModel>> subscribe(String categoryId) {
    var snapshots = _categoriesRef.doc(categoryId).collection('entries').snapshots();
    var result = snapshots.map<List<EntryModel>>((querySnapshot) {
      return querySnapshot.docs.map<EntryModel>((snapshot) {
        return EntryModel.fromJson(snapshot.data())..id = snapshot.id;
      }).toList();
    });

    return result;
  }

  @override
  Future<EntryModel> delete(String categoryId, String id) async {
    var document = _categoriesRef.doc('$categoryId/entries/$id');
    var entry = await get(categoryId, document.id);

    await document.delete();

    return entry;
  }

  @override
  Future<EntryModel> insert(String categoryId, EntryModel entry) async {
    var document =
        await _categoriesRef.doc(categoryId).collection('entries').add(entry.toJson());
    return await get(categoryId, document.id);
  }

  @override
  Future<List<EntryModel>> list(String categoryId) async {
    var entriesRef = _categoriesRef.doc(categoryId).collection('entries');
    var querySnapshot = await entriesRef.get();
    var entries = querySnapshot.docs
        .map((doc) => EntryModel.fromJson(doc.data())..id = doc.id)
        .toList();

    return entries;
  }

  @override
  Future<EntryModel> update(String categoryId, String id, EntryModel entry) async {
    var document = _categoriesRef.doc('$categoryId/entries/$id');
    await document.update(entry.toJson());
    var snapshot = await document.get();
    return EntryModel.fromJson(snapshot.data()!)..id = snapshot.id;
  }

  @override
  Future<EntryModel> get(String categoryId, String id) async {
    var document = _categoriesRef.doc('$categoryId/entries/$id');
    var snapshot = await document.get();
    return EntryModel.fromJson(snapshot.data()!)..id = snapshot.id;
  }
}
