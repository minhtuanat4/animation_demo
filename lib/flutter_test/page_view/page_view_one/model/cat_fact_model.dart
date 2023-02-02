class CatFact {
  String? fact;
  int? length;
  CatFact({this.fact, this.length});
  CatFact.fromJson(Map<String, dynamic> json) {
    fact = json['fact'];
    length = json['length'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fact'] = fact;
    data['length'] = length;
    return data;
  }

  CatFact copyWith({
    String? fact,
    int? length,
  }) =>
      CatFact(
        fact: fact ?? this.fact,
        length: length ?? this.length,
      );

  @override
  String toString() => 'Cat(fact: $fact, length: $length)';

  @override
  int get hashCode => fact.hashCode ^ length.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CatFact && other.fact == fact && other.length == length;
  }
}
