import 'package:flutter/material.dart';
import '../../core/services/test_service.dart';
import '../../models/question.dart';
import '../../models/test_answer.dart';
import '../../models/test_result.dart';

/// TestService 기능을 확인하기 위한 디버그 화면
class TestDebugScreen extends StatefulWidget {
  const TestDebugScreen({super.key});

  @override
  State<TestDebugScreen> createState() => _TestDebugScreenState();
}

class _TestDebugScreenState extends State<TestDebugScreen> {
  final TestService _testService = TestService();
  List<Question>? _questions;
  TestResult? _testResult;
  bool _isLoading = false;
  String _statusMessage = '대기 중...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADHD 테스트 디버그'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 상태 표시
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '상태: $_statusMessage',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 테스트 버튼들
            ElevatedButton(
              onPressed: _isLoading ? null : _loadTestData,
              child: const Text('1. JSON 데이터 로드'),
            ),

            const SizedBox(height: 8),

            ElevatedButton(
              onPressed: (_questions == null || _isLoading)
                  ? null
                  : _runSampleTest,
              child: const Text('2. 샘플 테스트 실행'),
            ),

            const SizedBox(height: 16),

            // 결과 표시
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '테스트 결과',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildResultContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultContent() {
    if (_questions == null) {
      return const Text('먼저 JSON 데이터를 로드해주세요.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('✅ 로드된 문항 수: ${_questions!.length}개'),
        const SizedBox(height: 8),

        // 문항 미리보기
        const Text(
          '📝 문항 미리보기:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ...(_questions!
            .take(3)
            .map(
              (q) => Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text(
                  '${q.id}. ${q.text.length > 50 ? '${q.text.substring(0, 50)}...' : q.text}',
                ),
              ),
            )),
        if (_questions!.length > 3)
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 4),
            child: Text('... (총 ${15}개 더)'),
          ),

        const SizedBox(height: 16),

        // 테스트 결과
        if (_testResult != null) ...[
          const Text(
            '🎯 테스트 결과:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('총점: ${_testResult!.totalScore}점'),
                Text('고위험 문항 수: ${_testResult!.highWeightCount}개'),
                Text(
                  '위험도: ${_testResult!.riskLevel.displayName} ${_testResult!.riskEmoji}',
                ),
                const SizedBox(height: 8),
                Text(
                  '설명: ${_testResult!.description}',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _loadTestData() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'JSON 데이터 로드 중...';
    });

    try {
      await _testService.loadTestData();
      final questions = _testService.getQuestions();

      setState(() {
        _questions = questions;
        _statusMessage = '데이터 로드 완료! ${questions.length}개 문항 로드됨';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '오류 발생: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _runSampleTest() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '샘플 테스트 실행 중...';
    });

    try {
      // 샘플 답변 생성 (중간 정도 위험도)
      final sampleAnswers = List.generate(18, (index) {
        final questionId = index + 1;
        final now = DateTime.now();

        // 1-6번 문항 중 절반은 고위험으로 답변
        if (questionId <= 6 && questionId % 2 == 1) {
          return TestAnswer(questionId: questionId, score: 2, answeredAt: now);
        }
        // 나머지는 적당한 점수
        return TestAnswer(questionId: questionId, score: 1, answeredAt: now);
      });

      final result = await _testService.calculateResult(sampleAnswers);

      setState(() {
        _testResult = result;
        _statusMessage = '샘플 테스트 완료!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _statusMessage = '테스트 실행 오류: $e';
        _isLoading = false;
      });
    }
  }
}
