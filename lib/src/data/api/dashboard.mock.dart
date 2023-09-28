// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:web_dashboard/src/data/api/category.mock.dart';
import 'package:web_dashboard/src/data/api/entry.mock.dart';
import 'package:web_dashboard/src/data/repositories/category.dart';
import 'package:web_dashboard/src/data/repositories/entry.dart';
import 'package:web_dashboard/src/models/category.dart';
import 'package:web_dashboard/src/models/entry.dart';

import '../repositories/dashboard.dart';

class DashboardMockData implements DashboardRepository {
  @override
  final EntryRepository entries = EntryMockData();

  @override
  final CategoryRepository categories = CategoryMockData();

  DashboardMockData();

  /// Creates a [DashboardMockData] filled with mock data for the last 30 days.
  Future<void> fillWithMockData() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    var category1 = await categories.insert(CategoryModel('Coffee (oz)'));
    var category2 = await categories.insert(CategoryModel('Running (miles)'));
    var category3 = await categories.insert(CategoryModel('Git Commits'));
    var monthAgo = DateTime.now().subtract(const Duration(days: 30));

    for (var category in [category1, category2, category3]) {
      for (var i = 0; i < 30; i++) {
        var date = monthAgo.add(Duration(days: i));
        var value = Random().nextInt(6) + 1;
        await entries.insert(category.id!, EntryModel(value, date));
      }
    }
  }
}
