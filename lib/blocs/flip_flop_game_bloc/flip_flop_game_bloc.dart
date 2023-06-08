import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flip_flop_game_event.dart';
part 'flip_flop_game_state.dart';

class FlipFlopGameBloc extends Bloc<FlipFlopGameEvent, FlipFlopGameState> {
  FlipFlopGameBloc() : super(FlipFlopGameInitial()) {
    on<FlipFlopGameEvent>((event, emit) {
      if (event is SetMatrixPikachuEvent) {
        emit(SetMatrixPikachuState());
      }
    });
  }
}
