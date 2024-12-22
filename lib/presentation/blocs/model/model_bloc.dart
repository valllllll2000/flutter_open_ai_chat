import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_gpt/domain/repositories/model_repository.dart';

part 'model_event.dart';

part 'model_state.dart';

class ModelBloc extends Bloc<ModelEvent, ModelState> {
  final ModelRepository _repository;

  ModelBloc(this._repository)
      : super(const ModelState(
            models: [], isLoading: true, currentModel: '', isError: false)) {
    on<LoadModels>(_loadModels);

    on<SelectModel>(_selectModel);
  }

  Future<void> _loadModels(LoadModels event, Emitter<ModelState> emit) async {
    try {
      final models = await _repository.getModels();
      emit(state.copyWith(
          models: models,
          isLoading: false,
          currentModel: models.first,
          isError: false));
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      emit(state.copyWith(isLoading: false, isError: true));
    }
  }

  void _selectModel(SelectModel event, Emitter<ModelState> emit) {
    final currentModel = _firstOrNull(event);
    if (currentModel != null) {
      emit(state.copyWith(currentModel: currentModel));
    }
  }

  String? _firstOrNull(SelectModel event) {
    try {
      return state.models.firstWhere((e) => e == event.value);
    } catch (e) {
      return null;
    }
  }
}
