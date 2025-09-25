enum BlocStatus { initial, loading, success, failure }

abstract class BlocState<T> {
  final BlocStatus status;
  final List<T> items;
  final String? search;

  const BlocState({
    this.status = BlocStatus.initial,
    this.items = const [],
    this.search,
  });

  BlocState<T> copyWith({
    BlocStatus? status,
    List<T>? items,
    String? Function()? search,
  });
}
