/// ADHD 테스트 문항을 나타내는 모델 클래스
class Question {
  final int id;
  final String text;
  final String category;
  final String part;
  final bool isHighWeight;
  final int threshold;

  const Question({
    required this.id,
    required this.text,
    required this.category,
    required this.part,
    required this.isHighWeight,
    required this.threshold,
  });

  /// JSON에서 Question 객체 생성
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      text: json['text'] as String,
      category: json['category'] as String,
      part: json['part'] as String,
      isHighWeight: json['is_high_weight'] as bool,
      threshold: json['threshold'] as int,
    );
  }

  /// Question 객체를 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'part': part,
      'is_high_weight': isHighWeight,
      'threshold': threshold,
    };
  }

  /// 주의력 결핍 문항인지 확인
  bool get isAttentionDeficit => category == 'attention_deficit';

  /// 과잉행동/충동성 문항인지 확인
  bool get isHyperactivityImpulsivity =>
      category == 'hyperactivity_impulsivity';

  @override
  String toString() {
    return 'Question{id: $id, text: $text, category: $category, part: $part, isHighWeight: $isHighWeight, threshold: $threshold}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Question && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
