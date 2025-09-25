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
