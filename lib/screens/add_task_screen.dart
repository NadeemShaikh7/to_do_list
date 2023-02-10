import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/to_do_bloc.dart';
import 'package:to_do_list/components/reusable_dropdown.dart';

import '../constants.dart';
import '../model/Task.dart';

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
  List<UnitListItem> items = [UnitListItem(displayItem: "Business",value: 0),UnitListItem(displayItem: "Personal",value: 1)];
  UnitListItem? currentSelected;
  final User? user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
    currentSelected = items[0];
  }

  onTypeChanged(value){
    print("nads - changed ");
    setState(() {
      currentSelected = value;
      print("nads after ${currentSelected?.displayItem}");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: Text('Create Task'),
      ),
      body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  ReusableDropDown(onChanged: ()=> onTypeChanged, initialValue: currentSelected!, items:items),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: controllerTitle,
                      decoration: const InputDecoration(
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.white70))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: controllerDesc,
                      decoration: InputDecoration(
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.white70))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                      controller: controllerDate,
                      onTap: _openDatePicker,
                      decoration: const InputDecoration(
                          hintText: 'Date',
                          hintStyle: TextStyle(color: Colors.white70))),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                      onPressed: () {
                        //ToDo
                        final task = Task(
                            done: false,
                            description: controllerDesc.text,
                            title: controllerTitle.text,
                            date: controllerDate.text,type: currentSelected?.displayItem);
                        BlocProvider.of<ToDoBloc>(context).firebaseRepository.createTask(task);
                        // createTask(task);
                        Navigator.pop(context,"Added");
                      },
                      child: Text('Add Task')),
                ],
              ),
            )
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
    docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('user_tasks')
        .doc();
    task.id = docTask.id;
    print('Nads ${docTask.id}');
    await docTask.set(task.toJson());
  }

}
