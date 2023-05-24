import 'package:hive/hive.dart';

import '../model/task.dart';

class TodoService {
  late Box<Task> _tasks;

  Future<void> init() async {
    Hive.registerAdapter(TaskAdapter());
    _tasks = await Hive.openBox<Task>('tasks');

    await _tasks.clear();

    // await _tasks.add(Task('test1', 'task 1', false));
    // await _tasks.add(Task('test1', 'task 2', true));
    // await _tasks.add(Task('test2', 'task 3', false));
    // await _tasks.add(Task('test2', 'task 55', true));
  }

  List<Task> getTasks(final String user) {
    final tasks = _tasks.values.where((element) => element.user == user);
    return tasks.toList();
  }

  Future<void> addTask(final String task, final String username) async {
    try {
      await _tasks.add(Task(username, task, false));
    } catch (error) {
      print(error);
    }
  }

  Future<void> removeTask(final String task, final String username) async {
    final taskToRemove = _tasks.values.firstWhere(
        (element) => element.task == task && element.user == username);
    await taskToRemove.delete();
    // as the task to remove is a hive object directly delete can be called upon it
  }

  Future<void> updateTask(final String task, final String username) async {
    final taskToEdit = _tasks.values.firstWhere(
        (element) => element.task == task && element.user == username);
    final index = taskToEdit.key as int;
    await _tasks.put(index, Task(username, task, !taskToEdit.completed));
  }
}
