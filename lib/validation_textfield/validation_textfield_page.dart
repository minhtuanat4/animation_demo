// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'validation_textfield_bloc/validation_textfield_bloc.dart';

enum FieldError { Empty, Invalid, None }

class ValidationTextFieldPage extends StatefulWidget {
  const ValidationTextFieldPage({Key? key}) : super(key: key);

  @override
  State<ValidationTextFieldPage> createState() =>
      _ValidationTextFieldPageState();
}

class _ValidationTextFieldPageState extends State<ValidationTextFieldPage> {
  final _emailController = TextEditingController();
  FieldError fieldErrorStatus = FieldError.None;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: BlocListener<ValidationTextfieldBloc, ValidationTextfieldState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is FormScreenSubmitState) {
            setState(() {
              fieldErrorStatus = state.fieldError;
            });
            if (state.submitIsSuccessed) {
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                      title: const Text('Submission success!'),
                      content: const Text("Your submission was a success"),
                      actions: [
                        ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ]);
                },
              );
            }
          }
        },
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 100),
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    style: TextStyle(
                      color: _hasEmailError(fieldErrorStatus)
                          ? Colors.red
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      labelStyle: TextStyle(
                        color: _hasEmailError(fieldErrorStatus)
                            ? Colors.red
                            : Colors.black,
                      ),
                      hintStyle: TextStyle(
                        color: _hasEmailError(fieldErrorStatus)
                            ? Colors.red
                            : Colors.black,
                      ),
                      enabledBorder: _renderBorder(fieldErrorStatus),
                      focusedBorder: _renderBorder(fieldErrorStatus),
                    ),
                  ),
                  if (_hasEmailError(fieldErrorStatus)) ...[
                    const SizedBox(height: 5),
                    Text(
                      _emailErrorText(fieldErrorStatus),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 30),
                  ElevatedButton(
                      child: const Text('Submit'),
                      onPressed: () {
                        context.read<ValidationTextfieldBloc>().add(
                            FormScreenSubmitEvent(
                                _emailController.text.trim()));
                      }),
                ],
              ),
            ),
            const CircularIndicator(),
          ],
        ),
      ),
    );
  }

  UnderlineInputBorder _renderBorder(FieldError state) => UnderlineInputBorder(
        borderSide: BorderSide(
            color: _hasEmailError(state) ? Colors.red : Colors.black, width: 1),
      );

  bool _hasEmailError(FieldError state) => state != FieldError.None;

  String _emailErrorText(FieldError error) {
    switch (error) {
      case FieldError.Empty:
        return 'You need to enter an email address';
      case FieldError.Invalid:
        return 'Email address invalid';
      default:
        return '';
    }
  }
}

class CircularIndicator extends StatefulWidget {
  const CircularIndicator({Key? key}) : super(key: key);

  @override
  State<CircularIndicator> createState() => _CircularIndicatorsState();
}

class _CircularIndicatorsState extends State<CircularIndicator> {
  bool isShowLoading = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ValidationTextfieldBloc, ValidationTextfieldState>(
      listener: (context, state) {
        if (state is ShowLoadingState) {
          isShowLoading = true;
        } else {
          isShowLoading = false;
        }
      },
      builder: (context, state) {
        return isShowLoading
            ? Container(
                color: Colors.black.withOpacity(0.2),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(188),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(22),
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              )
            : const SizedBox();
      },
    );
  }
}
