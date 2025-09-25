part of 'indicator_bloc.dart';

final class IndicatorState extends BlocState<BoardModel<IndicatorModel>> {
  const IndicatorState({super.status, super.items, super.search});

  @override
  IndicatorState copyWith({
    BlocStatus? status,
    List<BoardModel<IndicatorModel>>? items,
    String? Function()? search,
  }) {
    return IndicatorState(
      status: status ?? this.status,
      items: items ?? this.items,
      search: search != null ? search() : this.search,
    );
  }
}
