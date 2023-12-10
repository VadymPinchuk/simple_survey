class Vote {
  final String voterId;
  final String studentId;
  final double voteIdea;
  final double votePresentation;
  final double voteImplementation;
  final double voteAverage;

  Vote({
    required this.voterId,
    required this.studentId,
    required this.voteIdea,
    required this.votePresentation,
    required this.voteImplementation,
    required this.voteAverage,
  });

  factory Vote.fromJson(String id, Map<String, dynamic> json) {
    return Vote(
      voterId: json['voterId'],
      studentId: json['studentId'],
      voteIdea: json['voteIdea'] as double,
      votePresentation: json['votePresentation'] as double,
      voteImplementation: json['voteImplementation'] as double,
      voteAverage: json['voteAverage'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'voterId': voterId,
      'studentId': studentId,
      'voteIdea': voteIdea,
      'votePresentation': votePresentation,
      'voteImplementation': voteImplementation,
      'voteAverage': voteAverage,
    };
  }

  @override
  String toString() => toJson().toString();
}
