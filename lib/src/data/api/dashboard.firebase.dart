// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:web_dashboard/src/data/api/category.firebase.dart';
import 'package:web_dashboard/src/data/api/entry.firebase.dart';
import 'package:web_dashboard/src/data/repositories/category.dart';
import 'package:web_dashboard/src/data/repositories/entry.dart';

import '../repositories/dashboard.dart';

class DashboardFirebaseData implements DashboardRepository {
  @override
  final EntryRepository entries;

  @override
  final CategoryRepository categories;

  DashboardFirebaseData(FirebaseFirestore firestore, String userId)
      : entries = EntryFirebaseData(firestore, userId),
        categories = CategoryFirebaseData(firestore, userId);
}
