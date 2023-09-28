// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:web_dashboard/src/data/repositories/category.dart';
import 'package:web_dashboard/src/data/repositories/entry.dart';

/// Manipulates app data,
abstract class DashboardRepository {
  CategoryRepository get categories;
  EntryRepository get entries;
}
