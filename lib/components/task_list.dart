import 'package:flutter/cupertino.dart';
import 'package:to_do_list/components/task_item.dart';

import '../model/Task.dart';

class TaskList extends StatelessWidget {
  final List<Task>? taskList;

  TaskList({required this.taskList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: taskList!.map(buildTask).toList(),
    );
  }

  Widget buildTask(Task task) {
    return TaskItem(
      title: task.title!,
      subtitle: task.description!,
      isChecked: false,
      onClick: null,
    );
  }
}
