part of 'validation_textfield_bloc.dart';

abstract class ValidationTextfieldState extends Equatable {}

class ValidationTextfieldInitial extends ValidationTextfieldState {
  @override
  List<Object?> get props => [];
}

class FormScreenSubmitState extends ValidationTextfieldState {
  final FieldError fieldError;
  final bool submitIsSuccessed;

  FormScreenSubmitState({
    this.fieldError = FieldError.None,
    this.submitIsSuccessed = false,
  });
  @override
  List<Object?> get props => [];
}

class ShowLoadingState extends ValidationTextfieldState {
  @override
  List<Object?> get props => [];
}
