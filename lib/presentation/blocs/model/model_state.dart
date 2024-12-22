part of 'model_bloc.dart';

final class ModelState extends Equatable {
  const ModelState({
    required this.models,
    required this.isLoading,
    required this.currentModel,
    required this.isError,
  });

  final List<String> models;
  final bool isLoading;
  final String currentModel;
  final bool isError;

  ModelState copyWith({List<String>? models, bool? isLoading,
          String? currentModel, bool? isError}) =>
      ModelState(
          models: models ?? this.models,
          isLoading: isLoading ?? this.isLoading,
          currentModel: currentModel ?? this.currentModel,
          isError: isError ?? this.isError);

  @override
  List<Object> get props => [models, isLoading, currentModel, isError];
}
