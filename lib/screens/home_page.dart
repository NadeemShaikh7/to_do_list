import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/screens/login_screen.dart';
import 'package:to_do_list/screens/task_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return TaskScreen();
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        } else {
          return LoginScreen();
        }
      },
      stream: FirebaseAuth.instance.authStateChanges(),
    );
  }
}
