class BoardModel<T> {
  final int id;

  final List<T> items;

  const BoardModel({required this.id, required this.items});

  BoardModel<T> copyWith({int? id, List<T>? items}) {
    return BoardModel(id: id ?? this.id, items: items ?? this.items);
  }
}
