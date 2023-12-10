class Student {
  final String id;
  final String name;

  final double score;

  Student._({
    required this.id,
    required this.name,
    required this.score,
  });

  Student copyWith(double current) {
    return Student._(
      id: id,
      name: name,
      score: score,
    );
  }

  factory Student.fromJson(String id, Map<String, dynamic> json) {
    return Student._(
      id: id,
      name: json['name'],
      score: json['score'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
    };
  }

  @override
  String toString() => '{$id: $name, $score}';
}
