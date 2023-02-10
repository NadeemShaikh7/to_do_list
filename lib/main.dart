import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/bloc/to_do_bloc.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/provider/sign_in_provider.dart';
import 'package:to_do_list/repository/repository.dart';
import 'package:to_do_list/screens/add_task_screen.dart';
import 'package:to_do_list/screens/edit_task_screen.dart';
import 'package:to_do_list/screens/home_page.dart';
import 'package:to_do_list/screens/task_screen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: getRoutes(),
        initialRoute: kHomePage,
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> getRoutes() {
    final FirebaseRepository firebaseRepository = FirebaseRepository();
    final ToDoBloc toDoBloc = ToDoBloc(firebaseRepository: firebaseRepository);
    return <String, WidgetBuilder>{
      kHomePage: (BuildContext homePageContext) =>
          BlocProvider.value(
            value: toDoBloc,
            child: const HomePage(),
          ),
      kTaskPage: (BuildContext context) =>
          BlocProvider.value(
            value: toDoBloc,
            child: TaskScreen(),
          ),
      kAddPage: (BuildContext context) =>
          BlocProvider.value(
            value: toDoBloc,
            child: AddTaskScreen(),
          ),
      kEditPage: (BuildContext context) =>
          BlocProvider.value(
            value: toDoBloc,
            child: EditTaskScreen(),
          ),
    };
  }
}
