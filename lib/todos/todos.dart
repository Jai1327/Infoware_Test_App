import 'package:app/home/bloc/home_bloc.dart';
import 'package:app/services/todo.dart';
import 'package:app/todos/bloc/todos_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoPage extends StatelessWidget {
  final String username;

  const TodoPage({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo List"),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: EdgeInsets.all(5),
            child: TextButton(
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          )
        ],
      ),
      body: BlocProvider(
        create: (context) =>
            TodosBloc(RepositoryProvider.of<TodoService>(context))
              ..add(LoadTodosEvent(username)),
        child: BlocBuilder<TodosBloc, TodosState>(
          builder: (context, state) {
            if (state is TodosLoadedState) {
              return ListView(
                children: [
                  ...state.tasks.map(
                    (e) => ListTile(
                      title: Text(e.task),
                      trailing: Checkbox(
                        value: e.completed,
                        onChanged: (val) {
                          BlocProvider.of<TodosBloc>(context)
                              .add(ToggleTodoEvent(e.task));
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    trailing: const Icon(Icons.edit),
                    title: const Text("Create New Task"),
                    onTap: () async {
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => const Dialog(
                          child: CreateNewTask(),
                        ),
                      );

                      if (result != "") {
                        BlocProvider.of<TodosBloc>(context)
                            .add(AddTodosEvent(result.toString()));
                      }
                    },
                  )
                ],
              );
            }
            return Text(state.toString());
          },
        ),
      ),
    );
  }
}

class CreateNewTask extends StatefulWidget {
  const CreateNewTask({Key? key}) : super(key: key);

  @override
  State<CreateNewTask> createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> {
  final _inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Add the task here!"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _inputController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(_inputController.text);
            },
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }
}
