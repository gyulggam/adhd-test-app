import 'package:flutter/material.dart';
import '../../models/test_result.dart';
import '../../widgets/common/admob_banner.dart';

class TestResultScreen extends StatelessWidget {
  final TestResult result;

  const TestResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2E8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 헤더 (강력한 중앙정렬 적용)
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [_buildHeader()],
                ),
              ),
              const SizedBox(height: 32),

              // 전체 결과 요약 카드
              _buildSummaryCard(),
              const SizedBox(height: 24),

              // 영역별 분석
              _buildAreaAnalysis(),
              const SizedBox(height: 24),

              // 상세 설명
              _buildDetailedDescription(),
              const SizedBox(height: 24),

              // 맞춤 조언
              _buildAdviceSection(),
              const SizedBox(height: 24),

              // 광고 섹션
              _buildAdSection(),
              const SizedBox(height: 24),

              // 다음 단계 안내
              _buildNextSteps(),
              const SizedBox(height: 32),

              // 액션 버튼들
              _buildActionButtons(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 금쪽이 캐릭터 이미지 컨테이너
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getRiskColor().withOpacity(0.2),
                  _getRiskColor().withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: _getRiskColor().withOpacity(0.3),
                width: 3,
              ),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60), // 원형 클리핑
                child: Image.asset(
                  _getCharacterImage(), // 🖼️ 이미지로 변경!
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ADHD 위험도: ${_getCharacterType()}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _getRiskColor(),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getCharacterDescription(),
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF666666),
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '총 18문항 완료 • ${_formatDate(result.completedAt)}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADHD 위험도 ${_getCharacterType()}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D2D2D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '종합 평가 결과입니다',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _getRiskColor(),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _getRiskColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${result.totalScore}점',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _getRiskColor(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: result.totalScore / 54, // 최대 54점
              child: Container(
                decoration: BoxDecoration(
                  color: _getRiskColor(),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '총 54점 중 ${result.totalScore}점 ${_getScoreEmoji()}',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaAnalysis() {
    final attentionScore = result.attentionDeficitScore;
    final hyperactivityScore = result.hyperactivityImpulsivityScore;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 집중력 능력치',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 20),

          // 주의력 결핍
          _buildScoreItem(
            '🧠 집중력 & 주의력',
            attentionScore,
            27, // 최대 27점 (9문항 × 3점)
            const Color(0xFF2196F3),
          ),
          const SizedBox(height: 16),

          // 과잉행동/충동성
          _buildScoreItem(
            '⚡ 활동성 & 에너지',
            hyperactivityScore,
            27, // 최대 27점 (9문항 × 3점)
            const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreItem(String title, int score, int maxScore, Color color) {
    final percentage = score / maxScore;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D2D2D),
              ),
            ),
            Text(
              '$score/$maxScore',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percentage,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailedDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 주요 증상',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 16),
          ...result.mainSymptoms
              .map(
                (symptom) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          symptom,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildAdviceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🚀 개선방안 5가지',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 16),
          ...result.improvementTips
              .map(
                (tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '•',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tip,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildNextSteps() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9800).withOpacity(0.1),
            const Color(0xFFFFB74D).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFF9800).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFFFF9800), size: 24),
              SizedBox(width: 8),
              Text(
                '중요한 안내',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D2D2D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '이 테스트는 자가진단용이며, 의료진의 진단을 대체할 수 없습니다.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2D2D),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            result.riskLevel == TestRiskLevel.danger
                ? '🚨 결과가 위험 단계를 나타내므로, 즉시 정신건강의학과 전문의와 상담받으시길 강력히 권합니다.'
                : result.riskLevel == TestRiskLevel.attention
                ? '⚠️ 주의 단계로, 전문의와 상담받아보시는 것을 권합니다.'
                : result.riskLevel == TestRiskLevel.moderate
                ? '🤔 보통 단계로, 궁금한 점이 있다면 전문가와 상담해보세요.'
                : '😊 현재는 특별한 문제가 없어 보이나, 지속적인 증상이 있다면 전문의와 상담받아보세요.',
            style: const TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Color(0xFF666666),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // 메인 액션 버튼들
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // 다시하기 기능
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9800),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '다시 테스트하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  // 결과 저장 기능 (나중에 구현)
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('결과가 저장되었습니다.')));
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF9800),
                  side: const BorderSide(color: Color(0xFFFF9800)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '결과 저장하기',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // 처음으로 버튼
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              '처음으로 돌아가기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRiskColor() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return const Color(0xFF4CAF50);
      case TestRiskLevel.safe:
        return const Color(0xFF8BC34A);
      case TestRiskLevel.moderate:
        return const Color(0xFFFFC107);
      case TestRiskLevel.attention:
        return const Color(0xFFFF9800);
      case TestRiskLevel.danger:
        return const Color(0xFFF44336);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String _getDefaultDescription() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return '🌟 매우 안전한 수준의 결과입니다!\n현재 ADHD 관련 증상이 거의 나타나지 않으며, 일상생활에서 집중력과 활동성 모두 안정적인 상태입니다. 이러한 안정성을 유지하면서 건강한 생활 습관을 지속하시면 됩니다.';
      case TestRiskLevel.safe:
        return '✅ 안전한 수준의 결과입니다!\nADHD 관련 증상이 경미한 수준으로, 대부분의 상황에서 적절한 집중력과 활동성을 유지하고 있습니다. 현재의 균형 잡힌 상태를 유지하며, 스트레스 관리에 신경 쓰시면 좋겠습니다.';
      case TestRiskLevel.moderate:
        return '⚖️ 보통 수준의 결과입니다!\nADHD 증상이 보통 수준으로 나타나고 있어, 가끔 집중력이나 활동성 관련 어려움을 경험할 수 있습니다. 일상생활 패턴을 점검하고 필요시 전문가와 상담하는 것을 고려해보세요.';
      case TestRiskLevel.attention:
        return '⚠️ 주의가 필요한 수준입니다!\nADHD 증상이 상당한 수준으로 나타나고 있어, 일상생활에서 주의 깊은 관찰과 관리가 필요합니다. 집중력 유지나 충동 조절에 어려움이 있다면 전문가의 도움을 받아보시길 권합니다.';
      case TestRiskLevel.danger:
        return '🚨 즉시 전문적 도움이 필요합니다!\nADHD 증상이 심각한 수준으로, 일상생활에 상당한 어려움을 겪고 있을 가능성이 높습니다. 집중력 부족, 충동성, 과잉행동이 학업, 직장, 인간관계에 영향을 미칠 수 있어 정신건강의학과 전문의 진료가 필요합니다.';
    }
  }

  String _getDefaultAdvice() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return '🌟 매우 안전한 수준 관리법\n\n• 현재의 안정적인 상태를 유지하세요\n• 규칙적인 생활 패턴을 지속하세요\n• 스트레스 관리와 충분한 휴식을 취하세요\n• 정기적인 자기 점검을 통해 변화를 모니터하세요';
      case TestRiskLevel.safe:
        return '✅ 안전한 수준 관리법\n\n• 현재의 균형 잡힌 상태를 유지하세요\n• 건강한 생활습관을 지속하세요\n• 적절한 운동과 여가활동을 즐기세요\n• 새로운 도전과 학습 활동을 시도해보세요';
      case TestRiskLevel.moderate:
        return '⚖️ 보통 수준 관리법\n\n• 일상생활 패턴을 점검하고 개선하세요\n• 집중력 향상을 위한 환경을 조성하세요\n• 스마트폰 사용 시간을 줄여보세요\n• 필요시 전문가와 상담을 고려해보세요';
      case TestRiskLevel.attention:
        return '⚠️ 주의 수준 관리법\n\n• 전문가와 상담을 받아보시길 권합니다\n• 체계적인 일상 루틴을 구축하세요\n• 충동적 행동을 줄이는 훈련을 해보세요\n• 주변 지지체계의 도움을 적극 활용하세요';
      case TestRiskLevel.danger:
        return '🚨 위험 수준 즉시 조치\n\n• 정신건강의학과 전문의 진료가 필수입니다\n• 체계적인 치료 계획 수립이 필요합니다\n• 약물치료와 행동치료를 고려하세요\n• 가족 및 주변의 적극적 지원이 중요합니다';
    }
  }

  // 금쪽이 캐릭터 관련 메서드들 (5단계)
  String _getCharacterEmoji() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return '🐌';
      case TestRiskLevel.safe:
        return '🐱';
      case TestRiskLevel.moderate:
        return '🐿️';
      case TestRiskLevel.attention:
        return '🔥';
      case TestRiskLevel.danger:
        return '⚠️';
    }
  }

  // 단계별 이미지 경로 반환
  String _getCharacterImage() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return 'assets/images/1.png';
      case TestRiskLevel.safe:
        return 'assets/images/2.png';
      case TestRiskLevel.moderate:
        return 'assets/images/3.png';
      case TestRiskLevel.attention:
        return 'assets/images/4.png';
      case TestRiskLevel.danger:
        return 'assets/images/5.png';
    }
  }

  String _getCharacterSubEmoji() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return '💚';
      case TestRiskLevel.safe:
        return '😌';
      case TestRiskLevel.moderate:
        return '🌰';
      case TestRiskLevel.attention:
        return '🚨';
      case TestRiskLevel.danger:
        return '🆘';
    }
  }

  String _getCharacterType() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return '매우 안전한 수준';
      case TestRiskLevel.safe:
        return '안전한 수준';
      case TestRiskLevel.moderate:
        return '보통 수준';
      case TestRiskLevel.attention:
        return '주의 필요 수준';
      case TestRiskLevel.danger:
        return '위험 수준';
    }
  }

  String _getCharacterDescription() {
    switch (result.riskLevel) {
      case TestRiskLevel.verySafe:
        return 'ADHD 증상이 거의 나타나지 않습니다.\n일상생활에서 집중력과 활동성이 안정적입니다.';
      case TestRiskLevel.safe:
        return 'ADHD 증상이 경미한 수준입니다.\n대부분의 상황에서 적절한 집중력을 유지합니다.';
      case TestRiskLevel.moderate:
        return 'ADHD 증상이 보통 수준입니다.\n가끔 집중력이나 활동성 관련 어려움을 경험할 수 있습니다.';
      case TestRiskLevel.attention:
        return '⚠️ ADHD 증상이 상당한 수준입니다.\n일상생활에서 주의 깊은 관찰과 관리가 필요합니다.';
      case TestRiskLevel.danger:
        return '🚨 ADHD 증상이 심각한 수준입니다.\n전문의 진단과 치료가 강력히 권장됩니다.';
    }
  }

  String _getScoreEmoji() {
    if (result.totalScore <= 18) return '😌';
    if (result.totalScore <= 36) return '🤔';
    return '😎';
  }

  Widget _buildAdSection() {
    return const AdMobBanner();
  }
}
