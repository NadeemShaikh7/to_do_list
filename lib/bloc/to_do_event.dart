part of 'to_do_bloc.dart';


abstract class ToDoEvent extends Equatable {
  const ToDoEvent();
  @override
  List<Object?> get props => [];
}

class GetTasks extends ToDoEvent{
  // final User user;
  // const GetTasks(this.user);
}

class AddTask extends ToDoEvent{
  final Task task;

  AddTask(this.task);
}

class GetCount extends ToDoEvent{}
class UpdateTask extends ToDoEvent{
  final Task task;

  UpdateTask(this.task);
}
class GetTaskForUpdate extends ToDoEvent{
  final String taskId;

  GetTaskForUpdate(this.taskId);
}

class CreateTask extends ToDoEvent{
  final Task task;

  CreateTask(this.task);
}

class SelectTask extends ToDoEvent{
  final int taskId;

  const SelectTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

class OpenTask extends ToDoEvent{
  final int taskId;

  const OpenTask(this.taskId);

  @override
  List<Object?> get props => [taskId];
}
