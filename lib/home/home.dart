import 'package:app/home/bloc/home_bloc.dart';
import 'package:app/services/authentication.dart';
import 'package:app/services/todo.dart';
import 'package:app/todos/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatelessWidget {
  final usernameField = TextEditingController();
  final passwordField = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login to your account"),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc(
            RepositoryProvider.of<AuthenticationService>(context),
            RepositoryProvider.of<TodoService>(context))
          ..add(RegisterServicesEvent()),
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is SuccessfulLoginState) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TodoPage(username: state.userName),
                ),
              );
            }
            if (state is HomeInitial) {
              if (state.error != null) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: const Text("Error"),
                          content: Text(state.error!),
                        ));
              }
            }
          },
          builder: (context, state) {
            if (state is HomeInitial) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: const InputDecoration(labelText: 'Username'),
                      controller: usernameField,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      obscureText: true,
                      decoration: const InputDecoration(labelText: 'Password'),
                      controller: passwordField,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                            LoginEvent(usernameField.text, passwordField.text)),
                        child: const Text("Login"),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => BlocProvider.of<HomeBloc>(context).add(
                          RegisterAccountEvent(
                              usernameField.text, passwordField.text),
                        ),
                        child: const Text("Register"),
                      ),
                    ],
                  ),
                ],
              );
            }
            // print(state.toString());
            return Container(
              child: Text("hi"),
            );
          },
        ),
      ),
    );
  }
}
