import 'package:flutter_test/flutter_test.dart';
import 'package:adhd_check/core/services/test_service.dart';
import 'package:adhd_check/models/question.dart';
import 'package:adhd_check/models/test_answer.dart';
import 'package:adhd_check/models/test_result.dart';

void main() {
  group('TestService Tests', () {
    late TestService testService;

    setUp(() {
      testService = TestService();
      // 테스트 간 독립성을 위해 데이터 초기화
      testService.reset();
    });

    group('Data Loading Tests', () {
      test('JSON 데이터를 정상적으로 로드할 수 있다', () async {
        // Given: TestService 인스턴스

        // When: 데이터 로드
        await testService.loadTestData();

        // Then: 18개 질문이 로드되어야 함
        final questions = testService.getQuestions();
        expect(questions.length, 18);

        // 첫 번째 질문 확인
        final firstQuestion = questions.first;
        expect(firstQuestion.id, 1);
        expect(firstQuestion.text, contains('일을 끝내는 데 어려움'));
        expect(firstQuestion.isHighWeight, true);
      });

      test('질문을 ID로 찾을 수 있다', () async {
        // Given: 데이터가 로드된 상태
        await testService.loadTestData();

        // When: ID로 질문 검색
        final question = testService.getQuestionById(1);

        // Then: 올바른 질문이 반환되어야 함
        expect(question, isNotNull);
        expect(question!.id, 1);
        expect(question.isHighWeight, true);
      });

      test('존재하지 않는 ID로 검색하면 null을 반환한다', () async {
        // Given: 데이터가 로드된 상태
        await testService.loadTestData();

        // When: 존재하지 않는 ID로 검색
        final question = testService.getQuestionById(999);

        // Then: null이 반환되어야 함
        expect(question, isNull);
      });
    });

    group('Result Calculation Tests', () {
      test('저위험 결과를 정확히 계산한다', () async {
        // Given: 데이터 로드 및 저위험 답변 준비
        await testService.loadTestData();
        final answers = _createLowRiskAnswers();

        // When: 결과 계산
        final result = await testService.calculateResult(answers);

        // Then: 저위험으로 판정되어야 함
        expect(result.riskLevel, TestRiskLevel.verySafe);
        expect(result.answers.length, 18);
        expect(result.totalScore, lessThan(25));
        expect(result.highWeightCount, lessThan(4));
      });

      test('고위험 결과를 정확히 계산한다', () async {
        // Given: 데이터 로드 및 고위험 답변 준비
        await testService.loadTestData();
        final answers = _createHighRiskAnswers();

        // When: 결과 계산
        final result = await testService.calculateResult(answers);

        // Then: 고위험으로 판정되어야 함
        expect(result.riskLevel, TestRiskLevel.danger);
        expect(result.answers.length, 18);
        expect(result.totalScore, greaterThanOrEqualTo(40));
        expect(result.highWeightCount, greaterThanOrEqualTo(4));
      });

      test('불완전한 답변에 대해 예외를 처리한다', () async {
        // Given: 데이터 로드 및 불완전한 답변
        await testService.loadTestData();
        final incompleteAnswers = [
          TestAnswer(questionId: 1, score: 2, answeredAt: DateTime.now()),
          TestAnswer(questionId: 2, score: 1, answeredAt: DateTime.now()),
          // 16개 문항 누락
        ];

        // When: 결과 계산
        final result = await testService.calculateResult(incompleteAnswers);

        // Then: 빈 결과가 반환되어야 함 (에러 처리)
        expect(result.id, isEmpty);
        expect(result.totalScore, 0);
      });
    });

    group('Question Categorization Tests', () {
      test('주의력 결핍 문항들을 올바르게 분류한다', () async {
        // Given: 데이터 로드
        await testService.loadTestData();

        // When: 주의력 결핍 문항 조회
        final attentionQuestions = testService.getAttentionDeficitQuestions();

        // Then: 9개 문항이어야 함 (1-9번)
        expect(attentionQuestions.length, 9);
        expect(attentionQuestions.every((q) => q.isAttentionDeficit), true);
        expect(attentionQuestions.every((q) => q.id <= 9), true);
      });

      test('과잉행동/충동성 문항들을 올바르게 분류한다', () async {
        // Given: 데이터 로드
        await testService.loadTestData();

        // When: 과잉행동/충동성 문항 조회
        final hyperactivityQuestions = testService
            .getHyperactivityImpulsivityQuestions();

        // Then: 9개 문항이어야 함 (10-18번)
        expect(hyperactivityQuestions.length, 9);
        expect(
          hyperactivityQuestions.every((q) => q.isHyperactivityImpulsivity),
          true,
        );
        expect(hyperactivityQuestions.every((q) => q.id >= 10), true);
      });
    });

    group('Test Info Tests', () {
      test('테스트 정보를 올바르게 반환한다', () async {
        // Given: 데이터 로드
        await testService.loadTestData();

        // When: 테스트 정보 조회
        final testInfo = testService.getTestInfo();

        // Then: 올바른 정보가 반환되어야 함
        expect(testInfo, isNotNull);
        expect(testInfo!['title'], '어? hoxy ADHD인가?');
        expect(testInfo['total_questions'], 18);
      });

      test('점수 척도를 올바르게 반환한다', () async {
        // Given: 데이터 로드
        await testService.loadTestData();

        // When: 점수 척도 조회
        final scale = testService.getScoreScale();

        // Then: 4개 척도가 반환되어야 함
        expect(scale.length, 4);
        expect(scale[0], '전혀 아니다');
        expect(scale[1], '거의 아니다');
        expect(scale[2], '가끔 그렇다');
        expect(scale[3], '자주 그렇다');
      });
    });
  });
}

// 테스트 헬퍼 함수들

/// 저위험 답변 생성 (총점 낮음, 고위험 문항 적음)
List<TestAnswer> _createLowRiskAnswers() {
  return List.generate(18, (index) {
    final questionId = index + 1;
    final now = DateTime.now();

    // 1-6번 문항은 고위험 문항, 낮은 점수로 답변
    if (questionId <= 6) {
      return TestAnswer(questionId: questionId, score: 1, answeredAt: now);
    }
    // 나머지는 더 낮은 점수
    return TestAnswer(questionId: questionId, score: 0, answeredAt: now);
  });
}

/// 고위험 답변 생성 (총점 높음, 고위험 문항 많음)
List<TestAnswer> _createHighRiskAnswers() {
  return List.generate(18, (index) {
    final questionId = index + 1;
    final now = DateTime.now();

    // 1-6번 문항은 고위험 문항, 높은 점수로 답변
    if (questionId <= 6) {
      return TestAnswer(questionId: questionId, score: 3, answeredAt: now);
    }
    // 나머지도 비교적 높은 점수
    return TestAnswer(questionId: questionId, score: 2, answeredAt: now);
  });
}
