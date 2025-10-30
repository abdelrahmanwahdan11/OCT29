class Collection {
  Collection({
    required this.id,
    required this.name,
    List<String>? itemIds,
  }) : itemIds = List.unmodifiable(itemIds ?? const []);

  final String id;
  final String name;
  final List<String> itemIds;

  Collection copyWith({String? name, List<String>? itemIds}) {
    return Collection(
      id: id,
      name: name ?? this.name,
      itemIds: itemIds ?? this.itemIds,
    );
  }

  bool contains(String itemId) => itemIds.contains(itemId);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'itemIds': itemIds,
      };

  factory Collection.fromJson(Map<String, dynamic> json) {
    final rawIds = json['itemIds'];
    return Collection(
      id: json['id'] as String,
      name: json['name'] as String,
      itemIds: rawIds is List
          ? rawIds.map((id) => id.toString()).toList()
          : const <String>[],
    );
  }
}
