import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../model/Task.dart';
import '../repository/repository.dart';

part 'to_do_event.dart';
part 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  final FirebaseRepository firebaseRepository;
  ToDoBloc({required this.firebaseRepository}) : super(ToDoInitial()) {
    on<GetTasks>(mapGetTaskEventToState);
    on<CreateTask>(mapCreateTaskEventToState);
    on<GetCount>(mapGetCountEventToState);
    on<GetTaskForUpdate>(mapGetTaskForUpdateEventToState);
    on<UpdateTask>(mapUpdateTaskEventToState);
    on<AddTask>(mapAddTaskEventToState);
  }

  mapUpdateTaskEventToState(UpdateTask event,Emitter<ToDoState> emitter) async{
    // emitter(TasksLoading());
    try{
      await firebaseRepository.updateTask(event.task);
      emitter(EditPagePopped());
    }
    catch(error){
      emitter(GetTasksFailure(error.toString()));
    }
  }
  mapAddTaskEventToState(AddTask event,Emitter<ToDoState> emitter) async{
    try{
      await firebaseRepository.createTask(event.task);
      // emitter(AddSuccess());
    }
    catch(error){
      emitter(GetTasksFailure(error.toString()));
    }
  }


  mapGetTaskForUpdateEventToState(GetTaskForUpdate event,Emitter<ToDoState> emitter) async{
    emitter(TasksLoading());
    try{
      Task? task = await firebaseRepository.fetchTask(event.taskId);
      if(task !=null){
        emitter(GetTaskSuccess(task));
      }
    }
    catch(error){
      emitter(GetTasksFailure(error.toString()));
    }
  }
  mapGetTaskEventToState(GetTasks event,Emitter<ToDoState> emitter) async{
    emitter(TasksLoading());
    try{
      List<Task> tasks = await firebaseRepository.getTasks();
      if(tasks != null){
        emitter(GetTasksSuccess(tasks));
      }
    }
    catch(error){
    emitter(GetTasksFailure(error.toString()));
    }
  }

  mapGetCountEventToState(GetCount event,Emitter<ToDoState> emitter) async{
    emitter(TasksLoading());
    try{
      int tasks = await firebaseRepository.getCount();
      emitter(GetTaskCountSuccess(tasks));
    }
    catch(error){
      emitter(GetTasksFailure(error.toString()));
    }
  }

  mapCreateTaskEventToState(CreateTask event,Emitter<ToDoState> emitter) async{
    emitter(TasksLoading());
    try{
      await firebaseRepository.createTask(event.task);
    }
    catch(error,stacktrace){
      emitter(GetTasksFailure(error.toString()));
    }
  }
}

