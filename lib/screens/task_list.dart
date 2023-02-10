import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/bloc/to_do_bloc.dart';

import '../components/task_item.dart';
import '../constants.dart';
import '../model/Task.dart';
import '../provider/sign_in_provider.dart';
import '../repository/repository.dart';

class TaskLists extends StatefulWidget{
  final List<Task> tasks;
  final Function() onReturn;
  // final FutureOr onReturn;
  const TaskLists(this.tasks,this.onReturn, {Key? key}) : super(key: key);


  @override
  State createState() {
    return TaskListState();
  }
}

class TaskListState extends State<TaskLists>{

  onCLicked(BuildContext context, Task task) {
    print('onclicked');
    print("nads ${context.toString()}");
    Navigator.of(context)
        .pushNamed(kEditPage, arguments: task.id!)
        .then(widget.onReturn());
  }


  Widget buildTask(Task task, BuildContext context) {
    bool? isCheckedOrNot = task.done;
    return TaskItem(
      title: task.title!,
      subtitle: task.description!,
      isChecked: isCheckedOrNot!,
      onClick: () => onCLicked(context, task),
      onChanged: () =>
          (newState) {
        print('new STate = ${newState}');
        // setState(() {
        setState(() {
          isCheckedOrNot = newState;
          task.done = newState;
        });
        BlocProvider.of<ToDoBloc>(context).firebaseRepository.updateTask(task);
        // });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(
              top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  getCircleAvatar(BlocProvider.of<ToDoBloc>(context).firebaseRepository.user),
                  ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Provider.of<GoogleSignInProvider>(context,
                          listen: false)
                          .signOutGoogle();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                          color: Colors.indigoAccent,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                title,
                style: titleStyle,
              ),
              Text(
                '${widget.tasks.length ?? ""} Things',
                style: titleStyle.copyWith(
                    fontSize: 18.0, color: Colors.white70),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0))),
              child: widget.tasks.length > 0 ? ListView(
                children: List<Task>.from(widget.tasks)
                    .map((e) => buildTask(e, context))
                    .toList(),
              ) : SizedBox(),
          ),
        ),
      ],
    );
  }
  getCircleAvatar(User user) {
    try {
      return CircleAvatar(
        backgroundImage: NetworkImage(user.photoURL!),
        radius: 30.0,
        backgroundColor: Colors.white,
      );
    } catch (e) {
      return const CircleAvatar(
        child: Icon(
          Icons.list,
          size: 30.0,
          color: Colors.indigoAccent,
        ),
        radius: 30.0,
        backgroundColor: Colors.white,
      );
    }
  }
}