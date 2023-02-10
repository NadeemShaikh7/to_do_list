import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/to_do_bloc.dart';
import 'package:to_do_list/screens/login_screen.dart';
import 'package:to_do_list/screens/task_screen.dart';


class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    // final FirebaseRepository firebaseRepository = FirebaseRepository();
    // print(BlocProvider.of<ToDoBloc>(context).toString());
    return Scaffold(
      backgroundColor: Colors.cyan,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (streamBuilderContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          } else if (snapshot.hasData) {
            BlocProvider.of<ToDoBloc>(context).firebaseRepository.assignUser(FirebaseAuth.instance.currentUser!);
            return TaskScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong!'),
            );
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }


}
