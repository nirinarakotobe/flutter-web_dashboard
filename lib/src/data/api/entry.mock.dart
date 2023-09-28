import 'dart:async';

import 'package:collection/collection.dart';
import 'package:uuid/uuid.dart' as uuid;

import 'package:web_dashboard/src/data/repositories/entry.dart';
import 'package:web_dashboard/src/models/entry.dart';

class _EntriesEvent {
  final String categoryId;
  final List<EntryModel> entries;

  _EntriesEvent(this.categoryId, this.entries);
}

class EntryMockData implements EntryRepository {
  final Map<String, EntryModel> _storage = {};
  final StreamController<_EntriesEvent> _streamController = StreamController.broadcast();

  @override
  Future<EntryModel?> delete(String categoryId, String id) async {
    _emit(categoryId);
    return _storage.remove('$categoryId-$id');
  }

  @override
  Future<EntryModel> insert(String categoryId, EntryModel entry) async {
    var id = const uuid.Uuid().v4();
    var newEntry = EntryModel(entry.value, entry.time)..id = id;
    _storage['$categoryId-$id'] = newEntry;
    _emit(categoryId);
    return newEntry;
  }

  @override
  Future<List<EntryModel>> list(String categoryId) async {
    var list = _storage.keys
        .where((k) => k.startsWith(categoryId))
        .map((k) => _storage[k])
        .whereNotNull()
        .toList();
    return list;
  }

  @override
  Future<EntryModel> update(String categoryId, String id, EntryModel entry) async {
    _storage['$categoryId-$id'] = entry;
    _emit(categoryId);
    return entry..id = id;
  }

  @override
  Stream<List<EntryModel>> subscribe(String categoryId) {
    return _streamController.stream
        .where((event) => event.categoryId == categoryId)
        .map((event) => event.entries);
  }

  void _emit(String categoryId) {
    var entries = _storage.keys
        .where((k) => k.startsWith(categoryId))
        .map((k) => _storage[k]!)
        .toList();

    _streamController.add(_EntriesEvent(categoryId, entries));
  }

  @override
  Future<EntryModel?> get(String categoryId, String id) async {
    return _storage['$categoryId-$id'];
  }
}
