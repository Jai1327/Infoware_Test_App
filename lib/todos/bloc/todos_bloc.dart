import 'package:app/model/task.dart';
import 'package:app/services/todo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodoService _todoService;

  TodosBloc(this._todoService) : super(TodosInitial()) {
    on<LoadTodosEvent>((event, emit) {
      final todos = _todoService.getTasks(event.username);

      emit(TodosLoadedState(todos, event.username));
    });

    on<AddTodosEvent>((event, emit) {
      final currentState = state as TodosLoadedState;
      _todoService.addTask(event.todoText, currentState.username);
      add(LoadTodosEvent(currentState.username));
    });
    on<ToggleTodoEvent>((event, emit) async {
      final currentState = state as TodosLoadedState;
      await _todoService.updateTask(event.todoTask, currentState.username);
      add(LoadTodosEvent(currentState.username));
    });
  }
}
