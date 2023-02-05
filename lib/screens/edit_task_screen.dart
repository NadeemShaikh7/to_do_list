import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/reusable_dropdown.dart';
import '../constants.dart';
import '../model/Task.dart';

class EditTaskScreen extends StatefulWidget{
  @override
  State createState() {
    return _EditTaskScreenState();
  }
}

class _EditTaskScreenState extends State<EditTaskScreen>{
  Task? task;
  final controllerTitle = TextEditingController();
  final controllerDesc = TextEditingController();
  final controllerDate = TextEditingController();
  late String? id;
  bool dataLoaded = false;

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
  void didChangeDependencies() async{
    super.didChangeDependencies();
    id = ModalRoute.of(context)?.settings.arguments as String?;
    task = await fetchTask(id!);
    if(task?.type=="Personal") {
      // value = 1;
      // initialDisplayItem = "Personal";
      currentSelected = items[1];
    }
    else{
      currentSelected = items[0];
    }
    setState(() {
      dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: !dataLoaded ? const Center(child: CircularProgressIndicator(),) :
      Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  ReusableDropDown(onChanged: () => onTypeChanged, initialValue: currentSelected!, items: items),
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
                      decoration: const InputDecoration(
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
                        final taskToBeUpdated = Task(
                            done: false,
                            description: controllerDesc.text,
                            title: controllerTitle.text,
                            date: controllerDate.text,type: currentSelected?.displayItem);
                        updateTask(taskToBeUpdated);
                        Navigator.pop(context, 1);
                      },
                      child: Text('Add Task')),
                ],
              ),
            ),
          // }

        // },
      // ),
    );
  }

  fetchTask(String id) async {
    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('user_tasks')
        .doc(id);
    final snapshot = await docTask.get();
    if (snapshot.exists) {
      Task task = Task.fromJson(snapshot.data()!);
      controllerTitle.text = task.title!;
      controllerDate.text = task.date!;
      controllerDesc.text = task.description!;
      return task;
    }
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
  Future deleteTask(Task task) async {
    late final DocumentReference<Map<String, dynamic>> docTask;
    docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('user_tasks')
        .doc(task.id);
    // task.id = docTask.id;
    await docTask.delete();
  }
  Future updateTask(Task task) async {
    late final DocumentReference<Map<String, dynamic>> docTask;
    if (id == null) {
      docTask = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('user_tasks')
          .doc();
    } else {
      docTask = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('user_tasks')
          .doc(id);
    }
    task.id = docTask.id;
    await docTask.set(task.toJson());
  }
}

//
// StreamBuilder(
// stream: fetchTask(id!),
// builder: (context,snapshot){
// if (!snapshot.hasData) {
// return const Center(
// child: CircularProgressIndicator(
// color: Colors.white,
// ),
// );
// }
// else{
// task = snapshot.data as Task;
// int value=0;
// String initialDisplayItem = "Business";
// if(task?.type=="Personal") {
// value = 1;
// initialDisplayItem = "Personal";
// currentSelected = items[1];
// }
// else{
// currentSelected = items[0];
// }
//
//
// return Padding(
// padding: const EdgeInsets.all(25.0),
// child: Column(
// children: [
// ReusableDropDown(onChanged: () => onTypeChanged, initialValue: currentSelected!, items: items),
// const SizedBox(
// height: 20.0,
// ),
// TextField(
// controller: controllerTitle,
// decoration: const InputDecoration(
// hintText: 'Title',
// hintStyle: TextStyle(color: Colors.white70))),
// const SizedBox(
// height: 20.0,
// ),
// TextField(
// controller: controllerDesc,
// decoration: const InputDecoration(
// hintText: 'Description',
// hintStyle: TextStyle(color: Colors.white70))),
// const SizedBox(
// height: 20.0,
// ),
// TextField(
// controller: controllerDate,
// onTap: _openDatePicker,
// decoration: const InputDecoration(
// hintText: 'Date',
// hintStyle: TextStyle(color: Colors.white70))),
// const SizedBox(
// height: 20.0,
// ),
// ElevatedButton(
// style: ElevatedButton.styleFrom(
// primary: Colors.blue,
// ),
// onPressed: () {
// //ToDo
// final taskToBeUpdated = Task(
// done: false,
// description: controllerDesc.text,
// title: controllerTitle.text,
// date: controllerDate.text,type: currentSelected?.displayItem);
// updateTask(taskToBeUpdated);
// Navigator.pop(context, 1);
// },
// child: Text('Add Task')),
// ],
// ),
// );
// }
//
// },
// ),