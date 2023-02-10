import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/to_do_bloc.dart';

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
    Future.delayed(Duration.zero,(){
      id = ModalRoute.of(context)?.settings.arguments as String?;
      BlocProvider.of<ToDoBloc>(context).add(GetTaskForUpdate(id!));
      if(task?.type=="Personal") {
        currentSelected = items[1];
      }
      else{
        currentSelected = items[0];
      }
    });

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
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      body: BlocConsumer<ToDoBloc,ToDoState>(

          listener: (context, state) {
            if (state is GetTaskSuccess){
              print("nads values assigned");
              controllerTitle.text = state.task.title!;
              controllerDate.text = state.task.date!;
              controllerDesc.text = state.task.description!;
            }

          },
          builder: (_,state){
        if (state is GetTaskSuccess) {
          return Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                ReusableDropDown(onChanged: () => onTypeChanged,
                    initialValue: currentSelected!,
                    items: items),
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
                          id: id,
                          done: false,
                          description: controllerDesc.text,
                          title: controllerTitle.text,
                          date: controllerDate.text,
                          type: currentSelected?.displayItem);
                      BlocProvider.of<ToDoBloc>(context).add(UpdateTask(taskToBeUpdated));
                    },
                    child: Text('Add Task')),
              ],
            ),
          );
        }
        else if(state is EditPagePopped){

          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pop(context,1);
          });
        }
        print("nads screen loading");
        return Center(child: CircularProgressIndicator());
      }),
    );
  }

  void myCallback(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
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
}
