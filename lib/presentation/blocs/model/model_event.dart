part of 'model_bloc.dart';

abstract class ModelEvent {}

class LoadModels extends ModelEvent {}

class SelectModel extends ModelEvent {
  final String value;

  SelectModel(this.value);
}
