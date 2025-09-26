part of 'indicator_bloc.dart';

abstract class IndicatorEvent {
  const IndicatorEvent();
}

class IndicatorGetMoEvent extends IndicatorEvent {
  IndicatorGetMoEvent();
}

class IndicatorSearchMoEvent extends IndicatorEvent {
  final String? search;

  IndicatorSearchMoEvent(this.search);
}

class IndicatorUpdateMoEvent extends IndicatorEvent {
  final int indicatorId;
  final int parentId;
  final int order;

  IndicatorUpdateMoEvent({
    required this.indicatorId,
    required this.parentId,
    required this.order,
  });
}
