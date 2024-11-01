part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class GetUserState extends AuthState {
  final List<UserModel> response;
  const GetUserState(this.response);

  @override
  List<Object> get props => [response, DateTime.now()];
}

class GetCurrentUserState extends AuthState {
  final UserModel response;
  const GetCurrentUserState(this.response);

  @override
  List<Object> get props => [response, DateTime.now()];
}

class LoadingState extends AuthState {
  const LoadingState();

  @override
  List<Object> get props => [];
}
