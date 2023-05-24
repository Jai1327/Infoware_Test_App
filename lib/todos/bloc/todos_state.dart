part of 'todos_bloc.dart';

abstract class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

class TodosInitial extends TodosState {
  List<Object> get props => [];
}

class TodosLoadedState extends TodosState {
  final List<Task> tasks;
  final String username;

  TodosLoadedState(this.tasks, this.username);

  List<Object> get props => [
        tasks,
        username,
      ];
}
