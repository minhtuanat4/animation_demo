part of 'flip_flop_game_bloc.dart';

abstract class FlipFlopGameState extends Equatable {
  const FlipFlopGameState();

  @override
  List<Object> get props => [];
}

class FlipFlopGameInitial extends FlipFlopGameState {}

class SetMatrixPikachuState extends FlipFlopGameState {
  @override
  List<Object> get props => [DateTime.now()];
}
