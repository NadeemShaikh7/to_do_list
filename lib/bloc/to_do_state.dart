part of 'to_do_bloc.dart';


abstract class ToDoState extends Equatable {
  const ToDoState();
  @override
  List<Object> get props => [];
}

class ToDoInitial extends ToDoState {}

class GetTasksSuccess extends ToDoState{
  final List<Task> tasks;
  late final int taskCount;
   GetTasksSuccess(this.tasks){
     taskCount = tasks.length;
   }
  @override
  List<Object> get props => [tasks];
}
class AddSuccess extends ToDoState{}
class GetTaskSuccess extends ToDoState{
  final Task task;
  GetTaskSuccess(this.task);
  @override
  List<Object> get props => [task];
}

class GetTaskCountSuccess extends ToDoState{
  final int count;
  const GetTaskCountSuccess(this.count);
  @override
  List<Object> get props => [count];
}

class TasksLoading extends ToDoState{}
class EditPagePopped extends ToDoState{}

class GetTasksFailure extends ToDoState{
  final String error;

  const GetTasksFailure(this.error);
}
