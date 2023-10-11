// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:web_dashboard/src/data/repositories/auth.dart';

class AuthMockData implements AuthRepository {
  @override
  Future<bool> get isSignedIn async => false;

  @override
  Future<SessionUserRepository> signIn() async {
    return MockUserData();
  }

  @override
  Future signOut() async {
    return null;
  }
}

class MockUserData implements SessionUserRepository {
  @override
  String get uid => "123";
}
