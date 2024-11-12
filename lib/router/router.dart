import 'package:flutter/material.dart';
import 'package:flutter_application_coop/screens/login_screen.dart';
import 'package:flutter_application_coop/screens/main_screen.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/",
    errorPageBuilder: (context, state) {
      return const MaterialPage<dynamic>(
        child: Scaffold(
          body: Center(
            child: Text("This page is not found!!!"),
          ),
        ),
      );
    },
    routes: [
      //Login Page
      GoRoute(
        name: "login",
        path: "/",
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      //Home Page
      GoRoute(
        name: "home",
        path: "/home",
        builder: (context, state) {
          final String username = state.extra as String;
          final String name = state.extra as String;
          final String branch = state.extra as String;
          return MainScreen(
            username: username,
            name: name,
            branch: branch,
          );
        },
      ),
    ],
  );
}
