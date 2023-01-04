import 'package:animation_demo/validation_textfield/validation_textfield_page.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'validation_textfield_event.dart';
part 'validation_textfield_state.dart';

mixin ValidationMixin {
  bool isFieldEmpty(String fieldValue) => fieldValue.isEmpty;

  bool validateEmailAddress(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }
}

class ValidationTextfieldBloc
    extends Bloc<ValidationTextfieldEvent, ValidationTextfieldState>
    with ValidationMixin {
  ValidationTextfieldBloc() : super(ValidationTextfieldInitial()) {
    on<FormScreenSubmitEvent>((event, emit) async {
      await formScreenSubmitState(event, emit);
    });
  }

  Future<void> formScreenSubmitState(FormScreenSubmitEvent event,
      Emitter<ValidationTextfieldState> emit) async {
    emit(ShowLoadingState());

    await Future.delayed(const Duration(seconds: 3), () {
      if (isFieldEmpty(event.email)) {
        emit(FormScreenSubmitState(fieldError: FieldError.Empty));
        return;
      }
      if (validateEmailAddress(event.email)) {
        emit(FormScreenSubmitState(fieldError: FieldError.Invalid));
        return;
      }
      emit(FormScreenSubmitState(submitIsSuccessed: true));
    });
  }
}
