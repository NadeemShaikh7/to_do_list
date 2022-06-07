import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants.dart';

import '../components/task_item.dart';
import '../model/Task.dart';

class TaskScreen extends StatelessWidget {
  TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Logged in');
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.indigoAccent,
      body: Column(
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
                    getCircleAvatar(user),
                    ElevatedButton(
                      onPressed: () => FirebaseAuth.instance.signOut(),
                      child: Text(
                        'Logout',
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
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  title,
                  style: titleStyle,
                ),
                Text(
                  '12 Things',
                  style: titleStyle.copyWith(
                      fontSize: 18.0, color: Colors.white70),
                ),
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
              child: StreamBuilder(
                  // stream: FirebaseFirestore.instance
                  //     .collection('users')
                  //     .snapshots(),
                  stream: readTasks(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final tasks = snapshot.data! as List;
                    return ListView(
                      children: List<Task>.from(tasks)
                          .map((e) => buildTask(e, context))
                          .toList(),
                    );
                    // return ListView(
                    //   children: snapshot.data!.docs
                    //       .map((e) => TaskItem(
                    //           title: e['title'],
                    //           subtitle: e['description'],
                    //           isChecked: false))
                    //       .toList(),
                    // );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigoAccent,
        onPressed: () {
          if (kDebugMode) {
            print('onPressed');
          }
          Navigator.of(context).pushNamed(kAddPage).then((value) {
            if (value == 1) {
              const snackBar = SnackBar(
                content: Text('Added successfully!'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildTask(Task task, BuildContext context) {
    return TaskItem(
      title: task.title!,
      subtitle: task.description!,
      isChecked: false,
      onClick: () => onCLicked(context, task),
    );
  }

  Stream readTasks() {
    final stream = FirebaseFirestore.instance
        .collection('users')
        .snapshots()
        .map(
            (event) => event.docs.map((e) => Task.fromJson(e.data())).toList());
    return stream;
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

  onCLicked(BuildContext context, Task task) {
    print('onclicked');
    Navigator.of(context)
        .pushNamed(kAddPage, arguments: task.id!)
        .then((value) {
      String? text;
      if (value == 1) {
        text = 'Updated successfully!';
      } else if (value == 2) {
        text = 'Deleted successfully';
      }
      SnackBar snackBar = SnackBar(
        content: Text(text!),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
