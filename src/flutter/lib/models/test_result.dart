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
      riskLevel: TestRiskLevel.verySafe,
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
      case TestRiskLevel.verySafe:
        return '#4CAF50'; // 진한 초록색
      case TestRiskLevel.safe:
        return '#8BC34A'; // 연한 초록색
      case TestRiskLevel.moderate:
        return '#FFC107'; // 노란색
      case TestRiskLevel.attention:
        return '#FF9800'; // 주황색
      case TestRiskLevel.danger:
        return '#F44336'; // 빨간색
    }
  }

  /// 위험도별 이모지
  String get riskEmoji {
    switch (riskLevel) {
      case TestRiskLevel.verySafe:
        return '😊';
      case TestRiskLevel.safe:
        return '🙂';
      case TestRiskLevel.moderate:
        return '🤔';
      case TestRiskLevel.attention:
        return '😟';
      case TestRiskLevel.danger:
        return '😰';
    }
  }

  /// 위험도별 증상 설명 (공감형 메시지)
  String get symptomDescription {
    switch (riskLevel) {
      case TestRiskLevel.verySafe:
        return '집중력과 충동 조절이 잘 되고 있어요! 일상생활에서 큰 어려움 없이 잘 지내고 계시네요. 현재 상태를 유지하시면 됩니다.';
      case TestRiskLevel.safe:
        return '전반적으로 괜찮지만 가끔 집중하기 어렵거나 충동적인 순간들이 있을 수 있어요. 이는 매우 자연스러운 일이에요.';
      case TestRiskLevel.moderate:
        return '일상에서 집중력 부족이나 충동성으로 인한 어려움을 종종 경험하고 계시는군요. "왜 나만 이럴까?" 하는 생각이 들 때가 있죠? 충분히 이해할 수 있어요.';
      case TestRiskLevel.attention:
        return '집중하기 어렵고, 일을 끝까지 마치기 힘들거나, 충동적인 행동으로 후회한 적이 많으시군요. 혼자서 해결하려고 애쓰느라 정말 수고 많으셨어요.';
      case TestRiskLevel.danger:
        return '일상생활에서 상당한 어려움을 겪고 계시는군요. 집중력 문제나 충동성 때문에 힘든 순간들이 많았을 거예요. 전문가의 도움을 받으시는 것을 적극 권해드려요.';
    }
  }

  /// 위험도별 개선방안 5가지 추천
  List<String> get improvementTips {
    switch (riskLevel) {
      case TestRiskLevel.verySafe:
        return [
          '🧘‍♀️ 현재의 좋은 습관들을 꾸준히 유지하세요',
          '📚 새로운 도전이나 학습으로 뇌를 활성화하세요',
          '💪 규칙적인 운동으로 집중력을 더욱 향상시키세요',
          '🌱 스트레스 관리를 위한 취미활동을 즐기세요',
          '👥 주변 사람들과의 소통을 계속 이어가세요',
        ];
      case TestRiskLevel.safe:
        return [
          '⏰ 일정한 루틴을 만들어 하루를 구조화해보세요',
          '📝 중요한 일은 메모하는 습관을 기르세요',
          '🎯 한 번에 하나의 일에만 집중하도록 연습하세요',
          '😴 충분한 수면으로 뇌 기능을 최적화하세요',
          '🥗 균형잡힌 식사로 뇌 영양을 공급하세요',
        ];
      case TestRiskLevel.moderate:
        return [
          '📱 스마트폰이나 SNS 사용 시간을 제한해보세요',
          '🍅 포모도로 기법으로 25분씩 집중해보세요',
          '🧘‍♂️ 명상이나 깊은 호흡으로 마음을 진정시키세요',
          '📋 할 일 목록을 작성하고 우선순위를 정하세요',
          '🚶‍♀️ 매일 20분 이상 가벼운 산책을 해보세요',
        ];
      case TestRiskLevel.attention:
        return [
          '⚡ 충동적 결정 전에 "10초 멈춤" 규칙을 적용하세요',
          '🎵 집중할 때 백색소음이나 자연소리를 활용하세요',
          '📖 ADHD 관련 책이나 정보를 찾아 자신을 이해해보세요',
          '👨‍⚕️ 정신건강 전문가 상담을 고려해보세요',
          '💊 필요시 의료진과 약물치료 상담을 받아보세요',
        ];
      case TestRiskLevel.danger:
        return [
          '🏥 즉시 정신건강의학과 전문의 진료를 받으세요',
          '👥 가족이나 친구에게 현재 상황을 공유하세요',
          '📞 ADHD 관련 지원 단체나 상담 센터를 찾아보세요',
          '💡 작은 성공 경험부터 차근차근 쌓아보세요',
          '🤝 혼자 해결하려 하지 말고 주변의 도움을 받으세요',
        ];
    }
  }

  /// 위험도별 주요 증상 4가지
  List<String> get mainSymptoms {
    switch (riskLevel) {
      case TestRiskLevel.verySafe:
        return [
          '• 집중력을 오래 유지할 수 있어요',
          '• 계획한 일을 차근차근 완성해요',
          '• 충동적인 행동을 잘 조절해요',
          '• 조용한 환경에서 차분히 활동해요',
        ];
      case TestRiskLevel.safe:
        return [
          '• 가끔 집중이 흐트러지지만 금세 돌아와요',
          '• 대부분의 일을 계획대로 완료해요',
          '• 약간의 성급함이 있지만 조절 가능해요',
          '• 전반적으로 안정적인 일상을 유지해요',
        ];
      case TestRiskLevel.moderate:
        return [
          '• 책이나 업무에 집중하기 어려울 때가 많아요',
          '• 중요한 약속이나 일정을 자주 잊어버려요',
          '• 가만히 앉아있기 힘들고 계속 움직이고 싶어요',
          '• 말하기 전에 생각하지 않고 즉석에서 대답해요',
        ];
      case TestRiskLevel.attention:
        return [
          '• 일을 시작해도 끝까지 마치기 매우 힘들어요',
          '• 물건을 자주 잃어버리고 건망증이 심해요',
          '• 가만히 있지 못하고 손발을 계속 움직여요',
          '• 다른 사람 말을 끝까지 듣지 못하고 끼어들어요',
        ];
      case TestRiskLevel.danger:
        return [
          '• 집중력 부족으로 일상생활에 큰 지장이 있어요',
          '• 중요한 일들을 계속 미루거나 잊어버려요',
          '• 충동적 행동으로 인한 후회가 매우 많아요',
          '• 정신없이 바쁘게 움직이지만 성과가 없어요',
        ];
    }
  }

  @override
  String toString() {
    return 'TestResult{id: $id, totalScore: $totalScore, riskLevel: $riskLevel, completedAt: $completedAt}';
  }
}

/// ADHD 위험도 수준 (5단계)
enum TestRiskLevel {
  verySafe('매우 안전'),
  safe('안전'),
  moderate('보통'),
  attention('주의'),
  danger('위험');

  const TestRiskLevel(this.displayName);
  final String displayName;
}
