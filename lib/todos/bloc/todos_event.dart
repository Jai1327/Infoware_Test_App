part of 'todos_bloc.dart';

abstract class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodosEvent extends TodosEvent {
  final String username;

  LoadTodosEvent(this.username);

  @override
  List<Object?> get props => [username];
}

class AddTodosEvent extends TodosEvent {
  // final String username;
  final String todoText;

  AddTodosEvent(this.todoText);

  @override
  List<Object?> get props => [todoText];
}

class ToggleTodoEvent extends TodosEvent {
  final String todoTask;
  ToggleTodoEvent(this.todoTask);
  @override
  List<Object?> get props => [todoTask];
}
