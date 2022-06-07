import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isChecked;
  final Function? onClick;

  TaskItem(
      {required this.title,
      required this.subtitle,
      required this.isChecked,
      required this.onClick});

  @override
  State<StatefulWidget> createState() {
    return TaskItemState();
  }
}

class TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title),
      subtitle: Text(widget.subtitle),
      trailing: Checkbox(
        value: widget.isChecked,
        onChanged: (bool? value) {},
      ),
      onTap: () => widget.onClick!(),
    );
  }
}
