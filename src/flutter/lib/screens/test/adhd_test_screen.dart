import 'package:flutter/material.dart';
import '../../core/services/test_service.dart';
import '../../models/question.dart';
import '../../models/test_answer.dart';
import '../../models/test_result.dart';
import '../result/test_result_screen.dart';

/// 실제 사용자용 ADHD 테스트 화면
class AdhdTestScreen extends StatefulWidget {
  const AdhdTestScreen({super.key});

  @override
  State<AdhdTestScreen> createState() => _AdhdTestScreenState();
}

class _AdhdTestScreenState extends State<AdhdTestScreen>
    with TickerProviderStateMixin {
  final TestService _testService = TestService();

  List<Question>? _questions;
  List<TestAnswer> _answers = [];
  int _currentQuestionIndex = 0;
  bool _isLoading = true;
  String? _error;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadQuestions();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
  }

  Future<void> _loadQuestions() async {
    try {
      await _testService.loadTestData();
      final questions = _testService.getQuestions();

      setState(() {
        _questions = questions;
        _answers = List.filled(
          questions.length,
          TestAnswer(questionId: 0, score: -1, answeredAt: DateTime.now()),
        );
        _isLoading = false;
      });

      _fadeController.forward();
      _slideController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _selectAnswer(int score) {
    if (_questions == null) return;

    final currentQuestion = _questions![_currentQuestionIndex];
    final answer = TestAnswer(
      questionId: currentQuestion.id,
      score: score,
      answeredAt: DateTime.now(),
    );

    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions!.length - 1) {
      _slideController.reset();
      setState(() {
        _currentQuestionIndex++;
      });
      _slideController.forward();
    } else {
      _completeTest();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _slideController.reset();
      setState(() {
        _currentQuestionIndex--;
      });
      _slideController.forward();
    }
  }

  void _completeTest() async {
    try {
      final result = await _testService.calculateResult(_answers);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => TestResultScreen(result: result),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('테스트 완료 중 오류가 발생했습니다: $e')));
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F2E8),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFFF9800)),
              SizedBox(height: 16),
              Text('테스트 준비 중...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF5F2E8),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('오류가 발생했습니다\n$_error', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    final currentQuestion = _questions![_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions!.length;
    final currentAnswer = _answers[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F2E8), // 베이지 배경
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // 상단 진행 표시줄과 닫기 버튼
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.shade300,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFFF9800),
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 질문 번호
                Text(
                  '${_currentQuestionIndex + 1} / ${_questions!.length}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // 질문 텍스트
                Expanded(
                  flex: 2,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          currentQuestion.text,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D2D2D),
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),

                // 선택지 버튼들
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAnswerButton(
                        '전혀 아니다',
                        0,
                        '😊',
                        currentAnswer.score,
                      ),
                      const SizedBox(height: 8),
                      _buildAnswerButton(
                        '거의 아니다',
                        1,
                        '🙂',
                        currentAnswer.score,
                      ),
                      const SizedBox(height: 8),
                      _buildAnswerButton(
                        '가끔 그렇다',
                        2,
                        '😐',
                        currentAnswer.score,
                      ),
                      const SizedBox(height: 8),
                      _buildAnswerButton(
                        '자주 그렇다',
                        3,
                        '😟',
                        currentAnswer.score,
                      ),
                    ],
                  ),
                ),

                // 하단 네비게이션
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 이전 버튼
                    _currentQuestionIndex > 0
                        ? FloatingActionButton(
                            heroTag: "previous_button",
                            onPressed: _previousQuestion,
                            backgroundColor: Colors.white,
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.grey,
                            ),
                          )
                        : const SizedBox(width: 56), // 빈 공간
                    // 다음/완료 버튼 (답변이 선택된 경우에만 표시)
                    currentAnswer.score >= 0
                        ? FloatingActionButton(
                            heroTag: "next_button",
                            onPressed:
                                _currentQuestionIndex < _questions!.length - 1
                                ? _nextQuestion
                                : _completeTest,
                            backgroundColor: const Color(0xFFFF9800),
                            child: Icon(
                              _currentQuestionIndex < _questions!.length - 1
                                  ? Icons.arrow_forward
                                  : Icons.check,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(width: 56), // 빈 공간
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerButton(
    String text,
    int score,
    String emoji,
    int selectedScore,
  ) {
    final isSelected = selectedScore == score;

    return GestureDetector(
      onTap: () => _selectAnswer(score),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF9800) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9800) : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF2D2D2D),
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }
}
