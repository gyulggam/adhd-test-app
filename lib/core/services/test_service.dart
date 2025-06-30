import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
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

  /// 점수와 고위험 문항 개수를 바탕으로 위험도 결정
  Map<String, dynamic> _determineRiskLevel(
    int totalScore,
    int highWeightCount,
  ) {
    final criteria = _testData!['result_criteria'];

    // 고위험 (4개 이상 고위험 문항 + 총점 40 이상)
    if (highWeightCount >= 4 && totalScore >= 40) {
      return {
        'riskLevel': TestRiskLevel.high,
        'description': criteria['high_risk']['description'],
        'advice': criteria['high_risk']['advice'],
      };
    }

    // 중위험 (4개 고위험 문항 + 총점 25-39)
    if (highWeightCount == 4 && totalScore >= 25 && totalScore <= 39) {
      return {
        'riskLevel': TestRiskLevel.medium,
        'description': criteria['medium_risk']['description'],
        'advice': criteria['medium_risk']['advice'],
      };
    }

    // 저위험 (나머지)
    return {
      'riskLevel': TestRiskLevel.low,
      'description': criteria['low_risk']['description'],
      'advice': criteria['low_risk']['advice'],
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
