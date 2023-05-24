import 'dart:async';

import 'package:app/services/authentication.dart';
import 'package:app/services/todo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AuthenticationService _auth;
  final TodoService _todo;

  HomeBloc(this._auth, this._todo) : super(RegisteringServiceState()) {
    on<LoginEvent>((event, emitter) async {
      // print(event);
      final user = await _auth.authUser(event.username, event.password);
      if (user != null) {
        emit(SuccessfulLoginState(user));
        emit(HomeInitial());
      }
    });

    on<RegisterServicesEvent>((event, emit) async {
      await _auth.init();
      await _todo.init();
      emit(HomeInitial());
    });

    on<RegisterAccountEvent>((event, emit) async {
      final result = await _auth.createUser(event.username, event.password);

      switch (result) {
        case UserCreationResult.success:
          emit(SuccessfulLoginState(event.username));
          emit(HomeInitial());
          break;
        case UserCreationResult.failure:
          emit(HomeInitial(error: "There's been an error"));
          break;
        case UserCreationResult.exists:
          emit(HomeInitial(error: "Username already in use"));
          break;
      }
    });
  }
}
