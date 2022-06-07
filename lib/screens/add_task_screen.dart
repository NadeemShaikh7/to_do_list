import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../model/task.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  State createState() {
    return _AddTaskScreenState();
  }
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late final Task? task;
  final controllerTitle = TextEditingController();
  final controllerDesc = TextEditingController();
  final controllerDate = TextEditingController();
  late String? id;

  Future<Task?> fetchTask(String id) async {
    final docTask = FirebaseFirestore.instance.collection('users').doc(id);
    final snapshot = await docTask.get();
    if (snapshot.exists) {
      Task task = Task.fromJson(snapshot.data()!);
      controllerTitle.text = task.title!;
      controllerDate.text = task.date!;
      controllerDesc.text = task.description!;
      return task;
    }
  }

  // @override
  // Future<void> initState() async {
  //   task = await fetchTask(widget.id!);
  // }
  @override
  Widget build(BuildContext context) {
    String appBarTitle;
    id = ModalRoute.of(context)?.settings.arguments as String?;
    if (id == null) {
      appBarTitle = 'Create Task';
    } else {
      appBarTitle = 'Edit Task';
    }
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: id == null
          ? Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: controllerTitle,
                      decoration: InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.white70))),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: controllerDesc,
                      decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.white70))),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: controllerDate,
                      onTap: _openDatePicker,
                      decoration: InputDecoration(
                          hintText: 'Date',
                          hintStyle: TextStyle(color: Colors.white70))),
                  SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        //ToDo
                        final task = Task(
                            description: controllerDesc.text,
                            title: controllerTitle.text,
                            date: controllerDate.text);
                        createTask(task);
                        Navigator.pop(context, 1);
                      },
                      child: Text('Add Task')),
                ],
              ),
            )
          : FutureBuilder<Task?>(
              future: fetchTask(id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: controllerTitle,
                          decoration: InputDecoration(
                              hintText: 'Title',
                              hintStyle: TextStyle(color: Colors.white70))),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: controllerDesc,
                          decoration: InputDecoration(
                              hintText: 'Description',
                              hintStyle: TextStyle(color: Colors.white70))),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                          controller: controllerDate,
                          onTap: _openDatePicker,
                          decoration: InputDecoration(
                              hintText: 'Date',
                              hintStyle: TextStyle(color: Colors.white70))),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          onPressed: () {
                            //ToDo
                            final task = Task(
                                description: controllerDesc.text,
                                title: controllerTitle.text,
                                date: controllerDate.text);
                            createTask(task);
                            Navigator.pop(context, 1);
                          },
                          child: Text('Add Task')),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          deleteTask(snapshot.data!);
                          Navigator.pop(context, 2);
                        },
                        child: Text(
                          'Delete',
                          style: TextStyle(
                              color: Colors.indigoAccent,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }

  _openDatePicker() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    setState(() {
      controllerDate.text = dateFormatter(date!);
    });
    // print()
  }

  Future createTask(Task task) async {
    late final DocumentReference<Map<String, dynamic>> docTask;
    if (id == null) {
      docTask = FirebaseFirestore.instance.collection('users').doc();
    } else {
      docTask = FirebaseFirestore.instance.collection('users').doc(id);
    }
    task.id = docTask.id;
    await docTask.set(task.toJson());
  }

  Future deleteTask(Task task) async {
    late final DocumentReference<Map<String, dynamic>> docTask;
    docTask = FirebaseFirestore.instance.collection('users').doc(id);
    // task.id = docTask.id;
    await docTask.delete();
  }
}
