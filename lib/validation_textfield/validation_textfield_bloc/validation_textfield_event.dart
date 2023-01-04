part of 'validation_textfield_bloc.dart';

abstract class ValidationTextfieldEvent extends Equatable {}

class FormScreenSubmitEvent extends ValidationTextfieldEvent {
  final String email;

  FormScreenSubmitEvent(this.email);
  @override
  List<Object?> get props => [];
}

class ShowLoadingEvent extends ValidationTextfieldEvent {
  @override
  List<Object?> get props => [];
}
