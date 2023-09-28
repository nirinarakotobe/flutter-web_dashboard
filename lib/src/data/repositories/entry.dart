
import 'package:web_dashboard/src/models/entry.dart';

/// Manipulates [Entry] data.
abstract class EntryRepository {
  Future<EntryModel?> delete(String categoryId, String id);

  Future<EntryModel?> get(String categoryId, String id);

  Future<EntryModel> insert(String categoryId, EntryModel entry);

  Future<List<EntryModel>> list(String categoryId);

  Future<EntryModel> update(String categoryId, String id, EntryModel entry);

  Stream<List<EntryModel>> subscribe(String categoryId);
}

