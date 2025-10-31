class ComparisonSet {
  ComparisonSet({
    List<String>? ids,
    this.max = 3,
  }) : ids = ids ?? <String>[];

  final List<String> ids;
  final int max;

  bool get isFull => ids.length >= max;

  bool add(String id) {
    if (ids.contains(id)) {
      return true;
    }
    if (ids.length >= max) {
      return false;
    }
    ids.add(id);
    return true;
  }

  void remove(String id) => ids.remove(id);

  void clear() => ids.clear();
}
