import 'package:alona_note/start_session/sginin_page.dart';
import 'package:alona_note/start_session/sginup_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;
  void toggelScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginScreen(showRigisterPage: toggelScreens);
    } else {
      return SignUpPage(
        showSignInPage: toggelScreens,
      );
    }
  }
}
