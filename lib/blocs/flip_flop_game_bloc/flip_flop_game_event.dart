part of 'flip_flop_game_bloc.dart';

abstract class FlipFlopGameEvent extends Equatable {
  const FlipFlopGameEvent();

  @override
  List<Object> get props => [];
}

class SetMatrixPikachuEvent extends FlipFlopGameEvent {
  @override
  List<Object> get props => [DateTime.now()];
}
