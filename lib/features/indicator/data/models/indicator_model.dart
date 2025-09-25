class IndicatorModel {
  final String name;
  final int indicatorToMoId;
  final int parentId;
  final int order;

  IndicatorModel({
    required this.name,
    required this.indicatorToMoId,
    required this.parentId,
    required this.order,
  });

  factory IndicatorModel.fromMap(Map<String, dynamic> map) {
    return IndicatorModel(
      name: map["name"],
      indicatorToMoId: map["indicator_to_mo_id"],
      parentId: map["parent_id"],
      order: map["order"],
    );
  }
}
