// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:web_dashboard/src/data/repositories/auth.dart';

class AuthFirebaseData implements AuthRepository {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<bool> get isSignedIn => _googleSignIn.isSignedIn();

  @override
  Future<SessionUserRepository> signIn() async {
    try {
      return await _signIn();
    } on PlatformException {
      throw SignInException();
    }
  }

  Future<SessionUserRepository> _signIn() async {
    GoogleSignInAccount? googleUser;
    if (await isSignedIn) {
      googleUser = await _googleSignIn.signInSilently();
    } else {
      googleUser = await _googleSignIn.signIn();
    }

    var googleAuth = await googleUser!.authentication;

    var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    var authResult = await _auth.signInWithCredential(credential);

    return UserFirebaseData(authResult.user!.uid);
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}

class UserFirebaseData implements SessionUserRepository {
  @override
  final String uid;

  UserFirebaseData(this.uid);
}
