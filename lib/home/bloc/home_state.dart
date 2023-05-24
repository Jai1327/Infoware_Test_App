part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  // final bool? success;
  final String? error;
  HomeInitial({this.error});

  List<Object?> get props => [error];
}

class SuccessfulLoginState extends HomeState {
  final String userName;

  SuccessfulLoginState(this.userName);

  @override
  List<Object?> get props => [userName];
}

class RegisteringServiceState extends HomeState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
