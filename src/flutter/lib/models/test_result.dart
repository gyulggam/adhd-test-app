import 'test_answer.dart';

/// ADHD 테스트 결과를 나타내는 모델 클래스
class TestResult {
  final String id; // 고유 식별자
  final List<TestAnswer> answers;
  final DateTime completedAt;
  final int totalScore;
  final int highWeightCount; // 고위험 문항에서 기준치 이상 답변한 개수
  final TestRiskLevel riskLevel;
  final String description;
  final String advice;

  const TestResult({
    required this.id,
    required this.answers,
    required this.completedAt,
    required this.totalScore,
    required this.highWeightCount,
    required this.riskLevel,
    required this.description,
    required this.advice,
  });

  /// 빈 TestResult 객체 생성 (에러 처리용)
  factory TestResult.empty() {
    return TestResult(
      id: '',
      answers: [],
      completedAt: DateTime.now(),
      totalScore: 0,
      highWeightCount: 0,
      riskLevel: TestRiskLevel.low,
      description: '',
      advice: '',
    );
  }

  /// JSON에서 TestResult 객체 생성
  factory TestResult.fromJson(Map<String, dynamic> json) {
    return TestResult(
      id: json['id'] as String,
      answers: (json['answers'] as List)
          .map((e) => TestAnswer.fromJson(e))
          .toList(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      totalScore: json['totalScore'] as int,
      highWeightCount: json['highWeightCount'] as int,
      riskLevel: TestRiskLevel.values.firstWhere(
        (e) => e.name == json['riskLevel'],
      ),
      description: json['description'] as String,
      advice: json['advice'] as String,
    );
  }

  /// TestResult 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'answers': answers.map((e) => e.toJson()).toList(),
      'completedAt': completedAt.toIso8601String(),
      'totalScore': totalScore,
      'highWeightCount': highWeightCount,
      'riskLevel': riskLevel.name,
      'description': description,
      'advice': advice,
    };
  }

  /// 특정 질문의 답변 찾기
  TestAnswer? getAnswerByQuestionId(int questionId) {
    try {
      return answers.firstWhere((answer) => answer.questionId == questionId);
    } catch (e) {
      return null;
    }
  }

  /// 주의력 결핍 관련 점수
  int get attentionDeficitScore {
    return answers
        .where((answer) => answer.questionId <= 9)
        .map((answer) => answer.score)
        .fold(0, (sum, score) => sum + score);
  }

  /// 과잉행동/충동성 관련 점수
  int get hyperactivityImpulsivityScore {
    return answers
        .where((answer) => answer.questionId >= 10)
        .map((answer) => answer.score)
        .fold(0, (sum, score) => sum + score);
  }

  /// 테스트 완료 여부
  bool get isComplete => answers.length == 18;

  /// 위험도별 색상 (UI에서 사용)
  String get riskColor {
    switch (riskLevel) {
      case TestRiskLevel.low:
        return '#4CAF50'; // 초록색
      case TestRiskLevel.medium:
        return '#FF9800'; // 주황색
      case TestRiskLevel.high:
        return '#F44336'; // 빨간색
    }
  }

  /// 위험도별 이모지
  String get riskEmoji {
    switch (riskLevel) {
      case TestRiskLevel.low:
        return '😊';
      case TestRiskLevel.medium:
        return '🤔';
      case TestRiskLevel.high:
        return '😟';
    }
  }

  @override
  String toString() {
    return 'TestResult{id: $id, totalScore: $totalScore, riskLevel: $riskLevel, completedAt: $completedAt}';
  }
}

/// ADHD 위험도 수준
enum TestRiskLevel {
  low('낮음'),
  medium('보통'),
  high('높음');

  const TestRiskLevel(this.displayName);
  final String displayName;
}
