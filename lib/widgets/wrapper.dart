import 'package:flutter/material.dart';
import 'package:flutter_application_coop/screens/home_screen.dart';
import 'package:flutter_application_coop/screens/login_screen.dart';
import 'package:flutter_application_coop/screens/main_screen.dart';

class Wrapper extends StatefulWidget {
  final bool showMainScreen;
  const Wrapper({
    super.key,
    required this.showMainScreen,
  });

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return widget.showMainScreen
        ? const MainScreen(
            username: "1",
            name: "TEST",
            branch: "TEST",
          )
        : const LoginScreen();
  }
}
