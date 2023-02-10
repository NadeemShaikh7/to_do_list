import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/Task.dart';

class FirebaseRepository {
  late User user;

  assignUser(User user){
    this.user = user;
  }


  Future updateTask(Task task) async {
    late final DocumentReference<Map<String, dynamic>> docTask;
    docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('user_tasks')
        .doc(task.id);
    await docTask.set(task.toJson());
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

  Future deleteTask(Task task,User user) async {
    late final DocumentReference<Map<String, dynamic>> docTask;
    docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('user_tasks')
        .doc(task.id);
    // task.id = docTask.id;
    await docTask.delete();
  }

  Future<Task?> fetchTask(String id) async {
    final docTask = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('user_tasks')
        .doc(id);
    final snapshot = await docTask.get();
    if (snapshot.exists) {
      Task task = Task.fromJson(snapshot.data()!);
      // controllerTitle.text = task.title!;
      // controllerDate.text = task.date!;
      // controllerDesc.text = task.description!;
      return task;
    }
  }

  // Future updateTask(Task task,String id,User user) async {
  //   late final DocumentReference<Map<String, dynamic>> docTask;
  //   if (id == null) {
  //     docTask = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('user_tasks')
  //         .doc();
  //   } else {
  //     docTask = FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('user_tasks')
  //         .doc(id);
  //   }
  //   task.id = docTask.id;
  //   await docTask.set(task.toJson());
  // }

   Future<List<Task>> getTasks() async{
    List<Task> tasks = [];
    final stream = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('user_tasks')
        .get();
        // .map(
        //     (event) => event.docs.map((e) => Task.fromJson(e.data())).toList());
    // tasks = stream.docs.map((e) => Task.fromJson(e.data())).toList();
     stream.docs.forEach((element) {
       tasks.add(Task.fromJson(element.data()));
     });
     return tasks;
  }

  getCount() {
    print('Nads getCount');
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('user_tasks')
        .snapshots();
  }

}
