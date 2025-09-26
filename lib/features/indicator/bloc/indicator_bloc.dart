import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/core/bloc/common.dart';
import '/features/indicator/data/models/indicator_model.dart';
import '/features/indicator/data/repository/indicator_repository.dart';
import '/features/main/data/models/board_model.dart';

part 'indicator_event.dart';
part 'indicator_state.dart';

class IndicatorBloc extends Bloc<IndicatorEvent, IndicatorState> {
  final IndicatorRepository indicatorRepository;

  IndicatorBloc(this.indicatorRepository) : super(const IndicatorState()) {
    on<IndicatorGetMoEvent>(_onIndicatorGet);
    on<IndicatorSearchMoEvent>(_onIndicatorSearchGet);
    on<IndicatorUpdateMoEvent>(_onIndicatorUpdate);
  }

  Future<void> _onIndicatorGet(
    IndicatorGetMoEvent event,
    Emitter<IndicatorState> emit,
  ) async {
    try {
      final indicators = await indicatorRepository.getMoIndicators();
      final boards = indicators
          .groupListsBy((indicator) => indicator.parentId)
          .entries
          .map(
            (entry) =>
                BoardModel<IndicatorModel>(id: entry.key, items: entry.value),
          )
          .sortedBy((board) => board.id)
          .toList();
      emit(state.copyWith(status: BlocStatus.success, items: boards));
    } catch (_) {
      emit(state.copyWith(status: BlocStatus.failure));
    }
  }

  Future<void> _onIndicatorSearchGet(
    IndicatorSearchMoEvent event,
    Emitter<IndicatorState> emit,
  ) async {
    if (state.status == BlocStatus.success) {
      emit(state.copyWith(search: () => event.search));
    }
  }

  Future<void> _onIndicatorUpdate(
    IndicatorUpdateMoEvent event,
    Emitter<IndicatorState> emit,
  ) async {
    await indicatorRepository.updateMoIndicator(
      event.indicatorId,
      event.parentId,
      event.order,
    );
    add(IndicatorGetMoEvent());
  }
}
