import 'package:animation_demo/firebase_authenticate/service_firebase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final service = ServiceFirebase();
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is GetUserEvent) {
        try {
          final result = await service.getUser();
          emit(GetUserState(result));
        } catch (e) {}
      }
      if (event is GetCurrentUserEvent) {
        try {
          final result = await service.getCurrentUser();
          emit(GetCurrentUserState(result));
        } catch (e) {}
      }
    });
  }
}
