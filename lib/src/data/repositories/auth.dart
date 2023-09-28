// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'user.dart';

abstract class AuthRepository {
  Future<bool> get isSignedIn;
  Future<UserRepository> signIn();
  Future signOut();
}

class SignInException implements Exception {}
