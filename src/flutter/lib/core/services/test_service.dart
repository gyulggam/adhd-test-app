import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/question.dart';
import '../../models/test_answer.dart';
import '../../models/test_result.dart';

/// ADHD 테스트의 핵심 비즈니스 로직을 담당하는 서비스
class TestService {
  static final TestService _instance = TestService._internal();
  factory TestService() => _instance;
  TestService._internal();

  List<Question>? _questions;
  Map<String, dynamic>? _testData;

  /// JSON에서 테스트 데이터 로드
  Future<void> loadTestData() async {
    try {
      print('Loading ADHD test data...');
      final String jsonString = await rootBundle.loadString(
        'assets/data/adhd_questions.json',
      );
      _testData = json.decode(jsonString);

      final List<dynamic> questionList = _testData!['questions'];
      _questions = questionList.map((json) => Question.fromJson(json)).toList();

      print('Successfully loaded ${_questions!.length} questions');
    } catch (e) {
      print('Error loading test data: $e');
      throw Exception('테스트 데이터를 불러오는 중 오류가 발생했습니다: $e');
    }
  }

  /// 모든 질문 반환
  List<Question> getQuestions() {
    if (_questions == null) {
      throw Exception('테스트 데이터가 로드되지 않았습니다. loadTestData()를 먼저 호출하세요.');
    }
    return List.unmodifiable(_questions!);
  }

  /// 특정 질문 반환
  Question? getQuestionById(int id) {
    try {
      return _questions?.firstWhere((q) => q.id == id);
    } catch (e) {
      print('Question with id $id not found');
      return null;
    }
  }

  /// 답변 리스트를 받아서 TestResult 계산
  Future<TestResult> calculateResult(List<TestAnswer> answers) async {
    try {
      print('Calculating test result for ${answers.length} answers...');

      if (answers.length != 18) {
        throw Exception('모든 18개 문항에 답변해주세요. 현재 답변: ${answers.length}개');
      }

      // 1. 총점 계산
      final int totalScore = answers
          .map((a) => a.score)
          .fold(0, (sum, score) => sum + score);

      // 2. 고위험 문항 기준치 이상 답변 개수 계산
      int highWeightCount = 0;
      for (final answer in answers) {
        final question = getQuestionById(answer.questionId);
        if (question != null &&
            question.isHighWeight &&
            answer.score >= question.threshold) {
          highWeightCount++;
        }
      }

      // 3. 위험도 및 결과 설명 결정
      final Map<String, dynamic> resultData = _determineRiskLevel(
        totalScore,
        highWeightCount,
      );

      // 4. TestResult 객체 생성
      final result = TestResult(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        answers: List.unmodifiable(answers),
        completedAt: DateTime.now(),
        totalScore: totalScore,
        highWeightCount: highWeightCount,
        riskLevel: resultData['riskLevel'],
        description: resultData['description'],
        advice: resultData['advice'],
      );

      print(
        'Test result calculated: Total score: $totalScore, High weight count: $highWeightCount, Risk level: ${result.riskLevel}',
      );
      return result;
    } catch (e) {
      print('Error calculating result: $e');
      return TestResult.empty(); // 에러 시 기본값 반환
    }
  }

  /// 점수와 고위험 문항 개수를 바탕으로 위험도 결정 (5단계)
  Map<String, dynamic> _determineRiskLevel(
    int totalScore,
    int highWeightCount,
  ) {
    final criteria = _testData!['result_criteria'];

    // 5단계: 위험 (44-54점 또는 고위험 문항 6개 이상)
    if (totalScore >= 44 || highWeightCount >= 6) {
      return {
        'riskLevel': TestRiskLevel.danger,
        'description': criteria['high_risk']['description'] ?? '',
        'advice': criteria['high_risk']['advice'] ?? '',
      };
    }

    // 4단계: 주의 (33-43점 또는 고위험 문항 4-5개)
    if (totalScore >= 33 || highWeightCount >= 4) {
      return {
        'riskLevel': TestRiskLevel.attention,
        'description': criteria['medium_risk']['description'] ?? '',
        'advice': criteria['medium_risk']['advice'] ?? '',
      };
    }

    // 3단계: 보통 (22-32점 또는 고위험 문항 2-3개)
    if (totalScore >= 22 || highWeightCount >= 2) {
      return {
        'riskLevel': TestRiskLevel.moderate,
        'description': '일상생활에서 가끔 집중력이나 활동성 관련 어려움을 경험할 수 있습니다.',
        'advice': '생활 패턴을 점검하고 필요시 전문가와 상담받아보세요.',
      };
    }

    // 2단계: 안전 (11-21점)
    if (totalScore >= 11) {
      return {
        'riskLevel': TestRiskLevel.safe,
        'description': '대체로 안정적인 집중력과 활동성을 보이고 있습니다.',
        'advice': '현재 상태를 유지하며 건강한 생활 습관을 지켜나가세요.',
      };
    }

    // 1단계: 매우 안전 (0-10점)
    return {
      'riskLevel': TestRiskLevel.verySafe,
      'description': criteria['low_risk']['description'] ?? '',
      'advice': criteria['low_risk']['advice'] ?? '',
    };
  }

  /// 테스트 정보 반환
  Map<String, dynamic>? getTestInfo() {
    return _testData?['test_info'];
  }

  /// 점수 척도 반환
  List<String> getScoreScale() {
    final testInfo = getTestInfo();
    if (testInfo != null && testInfo['scoring'] != null) {
      return List<String>.from(testInfo['scoring']['scale']);
    }
    return ['전혀 아니다', '거의 아니다', '가끔 그렇다', '자주 그렇다'];
  }

  /// 주의력 결핍 문항들 반환 (1-9번)
  List<Question> getAttentionDeficitQuestions() {
    return getQuestions().where((q) => q.isAttentionDeficit).toList();
  }

  /// 과잉행동/충동성 문항들 반환 (10-18번)
  List<Question> getHyperactivityImpulsivityQuestions() {
    return getQuestions().where((q) => q.isHyperactivityImpulsivity).toList();
  }

  /// 데이터 초기화 (테스트용)
  void reset() {
    _questions = null;
    _testData = null;
  }
}
