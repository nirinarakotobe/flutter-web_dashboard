// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_dashboard/src/data/api/dashboard.firebase.dart';
import 'package:web_dashboard/src/data/api/dashboard.mock.dart';
import 'package:web_dashboard/src/data/repositories/dashboard.dart';

import 'data/repositories/auth.dart';
import 'data/auth/auth.firebase.dart';
import 'data/auth/auth.mock.dart';
import 'pages/home.dart';
import 'pages/sign_in.dart';

/// The global state the app.
class AppState {
  final AuthRepository auth;
  DashboardRepository? api;

  AppState(this.auth);
}

/// Creates a [DashboardRepository] for the given user. This allows users of this
/// widget to specify whether [DashboardMockData] or [ApiBuilder] should be
/// created when the user logs in.
typedef ApiBuilder = DashboardRepository Function(SessionUserRepository sessionUser);

/// An app that displays a personalized dashboard.
class DashboardApp extends StatefulWidget {
  final AuthRepository auth;
  final ApiBuilder apiBuilder;

  static DashboardRepository _mockApiBuilder(SessionUserRepository sessionUser) {
    return DashboardMockData()..fillWithMockData();
  }

  static DashboardRepository _firebaseApiBuilder(SessionUserRepository sessionUser) {
    return DashboardFirebaseData(FirebaseFirestore.instance, sessionUser.uid);
  }

  /// Runs the app using Firebase
  DashboardApp.firebase({super.key})
      : auth = AuthFirebaseData(),
        apiBuilder = _firebaseApiBuilder;

  /// Runs the app using mock data
  DashboardApp.mock({super.key})
      : auth = AuthMockData(),
        apiBuilder = _mockApiBuilder;

  @override
  State<DashboardApp> createState() => _DashboardAppState();
}

class _DashboardAppState extends State<DashboardApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState(widget.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: _appState,
      child: MaterialApp(
        theme: ThemeData.light(useMaterial3: true),
        home: SignInSwitcher(
          appState: _appState,
          apiBuilder: widget.apiBuilder,
        ),
      ),
    );
  }
}

/// Switches between showing the [SignInPage] or [HomePage], depending on
/// whether or not the user is signed in.
class SignInSwitcher extends StatefulWidget {
  final AppState? appState;
  final ApiBuilder? apiBuilder;

  const SignInSwitcher({
    this.appState,
    this.apiBuilder,
    super.key,
  });

  @override
  State<SignInSwitcher> createState() => _SignInSwitcherState();
}

class _SignInSwitcherState extends State<SignInSwitcher> {
  bool _isSignedIn = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      duration: const Duration(milliseconds: 200),
      child: _isSignedIn
          ? HomePage(
              onSignOut: _handleSignOut,
            )
          : SignInPage(
              auth: widget.appState!.auth,
              onSuccess: _handleSignIn,
            ),
    );
  }

  void _handleSignIn(SessionUserRepository sessionUser) {
    widget.appState!.api = widget.apiBuilder!(sessionUser);

    setState(() {
      _isSignedIn = true;
    });
  }

  Future _handleSignOut() async {
    await widget.appState!.auth.signOut();
    setState(() {
      _isSignedIn = false;
    });
  }
}
