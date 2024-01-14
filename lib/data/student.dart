class Student {
  final String id;
  final String name;

  final double score;

  Student._({
    required this.id,
    required this.name,
    required this.score,
  });

  String getInitials() {
    String initials = '';

    for (String name in name.split(' ')) {
      if (name.isNotEmpty) {
        initials += name[0].toUpperCase();
      }
    }
    return initials;
  }

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
      score: json['score'].toDouble(),
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
