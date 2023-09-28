// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:web_dashboard/src/data/repositories/user.dart';

import '../repositories/auth.dart';
import 'mock.user.dart';

class MockAuthData implements AuthRepository {
  @override
  Future<bool> get isSignedIn async => false;

  @override
  Future<UserRepository> signIn() async {
    return MockUserData();
  }

  @override
  Future signOut() async {
    return null;
  }
}
