import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/to_do_bloc.dart';
import 'package:to_do_list/constants.dart';
import 'package:to_do_list/screens/task_list.dart';


class TaskScreen extends StatefulWidget {
  TaskScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TaskScreenSate();
  }
}

class TaskScreenSate extends State<TaskScreen> {
  int? length;
  User? user;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ToDoBloc>(context).add(GetTasks());
  }

  FutureOr onReturn(dynamic value){
    String? text;
    if(value != null){
      if (value == 1) {
        text = 'Updated successfully!';
      } else if (value == 2) {
        text = 'Deleted successfully';
      }
      SnackBar snackBar = SnackBar(
        content: Text(text!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    BlocProvider.of<ToDoBloc>(context).add(GetTasks());
  }

  @override
  Widget build(BuildContext taskContext) {
    print('Logged in');
    user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: BlocConsumer<ToDoBloc, ToDoState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if(state is GetTasksSuccess){
            return TaskLists(state.tasks,()=>afterPopping);
          }

          return Center(child: CircularProgressIndicator());

        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          if (kDebugMode) {
            print('onPressed');
          }
          Navigator.of(context).pushNamed(kAddPage).then(afterPopping);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  FutureOr<void> afterPopping(value) {
    String snackBarText = "";
    SnackBar snackBar;
    if (value == "Added") {
      snackBarText = "Added Successfully!";
      snackBar = getSnackbar(snackBarText);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else if (value == 1) {
      snackBarText = 'Updated successfully!';
      snackBar = getSnackbar(snackBarText);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (value == 2) {
      snackBarText = 'Deleted successfully';
      snackBar = getSnackbar(snackBarText);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    BlocProvider.of<ToDoBloc>(context).add(GetTasks());
  }

  SnackBar getSnackbar(String value) {
    return SnackBar(
      content: Text(value),
    );
  }


}


