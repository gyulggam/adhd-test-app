/// 사용자의 테스트 답변을 나타내는 모델 클래스
class TestAnswer {
  final int questionId;
  final int score; // 0: 전혀 아니다, 1: 거의 아니다, 2: 가끔 그렇다, 3: 자주 그렇다
  final DateTime answeredAt;

  const TestAnswer({
    required this.questionId,
    required this.score,
    required this.answeredAt,
  });

  /// JSON에서 TestAnswer 객체 생성
  factory TestAnswer.fromJson(Map<String, dynamic> json) {
    return TestAnswer(
      questionId: json['questionId'] as int,
      score: json['score'] as int,
      answeredAt: DateTime.parse(json['answeredAt'] as String),
    );
  }

  /// TestAnswer 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'score': score,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }

  /// 답변 텍스트 반환
  String get answerText {
    switch (score) {
      case 0:
        return '전혀 아니다';
      case 1:
        return '거의 아니다';
      case 2:
        return '가끔 그렇다';
      case 3:
        return '자주 그렇다';
      default:
        return '알 수 없음';
    }
  }

  /// 고위험 문항인지 확인 (점수가 2 이상인 경우)
  bool get isHighRiskAnswer => score >= 2;

  /// 일반 문항인지 확인 (점수가 1 이상인 경우)
  bool get isNormalRiskAnswer => score >= 1;

  /// 다른 점수로 복사본 생성
  TestAnswer copyWith({int? questionId, int? score, DateTime? answeredAt}) {
    return TestAnswer(
      questionId: questionId ?? this.questionId,
      score: score ?? this.score,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  String toString() {
    return 'TestAnswer{questionId: $questionId, score: $score, answeredAt: $answeredAt}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestAnswer &&
          runtimeType == other.runtimeType &&
          questionId == other.questionId;

  @override
  int get hashCode => questionId.hashCode;
}
