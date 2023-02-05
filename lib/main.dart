import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/provider/sign_in_provider.dart';
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
        theme: ThemeData(
          fontFamily: 'Raleway',
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }

  Map<String, WidgetBuilder> getRoutes() {
    return <String, WidgetBuilder>{
      kHomePage: (BuildContext context) => HomePage(),
      kTaskPage: (BuildContext context) => TaskScreen(),
      kAddPage: (BuildContext context) => AddTaskScreen(),
      kEditPage: (BuildContext context) => EditTaskScreen(),
    };
  }
}
