import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatefulWidget {
  String title;
  String subtitle;
  bool isChecked;
  Function? onClick;
  Function()? onChanged;

  TaskItem(
      {required this.title,
      required this.subtitle,
      required this.isChecked,
      required this.onClick,
      required this.onChanged});

  @override
  State<StatefulWidget> createState() {
    return TaskItemState();
  }
}

class TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title,
          style: widget.isChecked
              ? TextStyle(decoration: TextDecoration.lineThrough)
              : null),
      subtitle: Text(widget.subtitle),
      trailing: Checkbox(
        value: widget.isChecked,
        onChanged: widget.onChanged!(),
      ),
      onTap: () => widget.onClick!(),
    );
  }

  void callBack(newState) {
    setState(() {
      widget.isChecked = newState;
    });
  }
}
