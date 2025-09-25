import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/bloc/common.dart';
import '../../main/data/models/board_model.dart';
import '../data/models/indicator_model.dart';
import '../data/repository/Indicator_repository.dart';

part 'indicator_event.dart';
part 'indicator_state.dart';

class IndicatorBloc extends Bloc<IndicatorEvent, IndicatorState> {
  final IndicatorRepository indicatorRepository;

  IndicatorBloc(this.indicatorRepository) : super(const IndicatorState()) {
    on<IndicatorGetMoEvent>(_onIndicatorGet);
    on<IndicatorSearchMoEvent>(_onIndicatorSearchGet);
  }

  Future<void> _onIndicatorGet(
    IndicatorGetMoEvent event,
    Emitter<IndicatorState> emit,
  ) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      final indicators = await indicatorRepository.getMoIndicators();
      final boards = indicators
          .groupListsBy((indicator) => indicator.parentId)
          .entries
          .map(
            (entry) =>
                BoardModel<IndicatorModel>(id: entry.key, items: entry.value),
          )
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
}
