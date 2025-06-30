# 🛠 개발 가이드

## 📋 목차
1. [개발 환경 설정](#개발-환경-설정)
2. [프로젝트 구조](#프로젝트-구조)
3. [개발 단계별 가이드](#개발-단계별-가이드)
4. [코딩 컨벤션](#코딩-컨벤션)
5. [테스트 가이드](#테스트-가이드)
6. [배포 가이드](#배포-가이드)

---

## 🔧 개발 환경 설정

### 필수 도구 설치

#### 1. Flutter SDK 설치
```bash
# macOS 기준
brew install --cask flutter

# Flutter 버전 확인
flutter --version
# 요구사항: Flutter 3.16.0+
```

#### 2. 개발 도구
- **Android Studio**: Android 개발 및 에뮬레이터
- **VS Code**: 가벼운 에디터 (추천 확장프로그램: Flutter, Dart)
- **Xcode**: iOS 개발 (Mac 필수)

#### 3. Firebase 설정
```bash
# Firebase CLI 설치
npm install -g firebase-tools

# Firebase 로그인
firebase login
```

### 개발 환경 검증
```bash
flutter doctor
# 모든 항목이 ✅ 상태가 되어야 함
```

---

## 📁 프로젝트 구조

```
adhd-test-app/
├── src/flutter/                 # Flutter 앱 소스코드
│   ├── lib/
│   │   ├── main.dart           # 앱 진입점
│   │   ├── core/               # 핵심 기능
│   │   │   ├── constants/      # 상수 정의
│   │   │   ├── utils/          # 유틸리티 함수
│   │   │   └── services/       # 서비스 (API, DB 등)
│   │   ├── models/             # 데이터 모델
│   │   │   ├── question.dart   # 테스트 문항 모델
│   │   │   ├── result.dart     # 결과 모델
│   │   │   └── user.dart       # 사용자 모델
│   │   ├── screens/            # 화면 위젯
│   │   │   ├── onboarding/     # 온보딩
│   │   │   ├── test/           # 테스트 진행
│   │   │   ├── result/         # 결과 화면
│   │   │   └── info/           # 정보 화면
│   │   ├── widgets/            # 재사용 가능한 위젯
│   │   │   ├── common/         # 공통 위젯
│   │   │   └── test/           # 테스트 관련 위젯
│   │   └── providers/          # 상태 관리 (Provider)
│   ├── assets/
│   │   ├── images/             # 이미지 파일
│   │   ├── fonts/              # 폰트 파일
│   │   └── data/               # JSON 데이터
│   ├── test/                   # 단위 테스트
│   ├── integration_test/       # 통합 테스트
│   ├── pubspec.yaml           # 패키지 의존성
│   └── README.md
```

---

## 🚀 개발 단계별 가이드

### Phase 1: 프로젝트 초기 설정 (1주차)

#### 1.1 Flutter 프로젝트 생성
```bash
cd src/
flutter create flutter --project-name adhd_check --org com.example
cd flutter
```

#### 1.2 기본 의존성 추가 (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # 상태 관리
  provider: ^6.1.1
  
  # 데이터베이스
  sqflite: ^2.3.0
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
  
  # 광고
  google_mobile_ads: ^4.0.0
  
  # UI
  flutter_svg: ^2.0.9
  
  # 유틸리티
  shared_preferences: ^2.2.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

#### 1.3 기본 폴더 구조 생성
```bash
mkdir -p lib/{core,models,screens,widgets,providers}
mkdir -p lib/core/{constants,utils,services}
mkdir -p lib/screens/{onboarding,test,result,info}
mkdir -p assets/{images,fonts,data}
```

### Phase 2: 핵심 기능 개발 (2-4주차)

#### 2.1 데이터 모델 생성
```dart
// lib/models/question.dart
class Question {
  final int id;
  final String text;
  final String category;
  final bool isHighWeight;
  
  Question({
    required this.id,
    required this.text,
    required this.category,
    required this.isHighWeight,
  });
}
```

#### 2.2 테스트 로직 구현
```dart
// lib/core/services/test_service.dart
class TestService {
  List<Question> getQuestions() {
    // JSON에서 문항 로드
  }
  
  TestResult calculateResult(Map<int, int> answers) {
    // 점수 계산 로직
  }
}
```

#### 2.3 화면 구현 순서
1. **온보딩 화면**: 앱 소개 및 안내
2. **테스트 화면**: 문항 표시 및 응답 수집
3. **결과 화면**: 분석 결과 및 조언 표시
4. **정보 화면**: ADHD 관련 정보 제공

### Phase 3: UI/UX 개발 (4-5주차)

#### 3.1 디자인 시스템 구축
```dart
// lib/core/constants/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
}
```

#### 3.2 공통 위젯 개발
- 진행률 표시기
- 커스텀 버튼
- 결과 차트
- 로딩 인디케이터

### Phase 4: 데이터 저장 (5-6주차)

#### 4.1 SQLite 데이터베이스 설정
```dart
// lib/core/services/database_service.dart
class DatabaseService {
  Future<void> saveTestResult(TestResult result) async {
    // 결과 저장
  }
  
  Future<List<TestResult>> getTestHistory() async {
    // 히스토리 조회
  }
}
```

### Phase 5: 광고 연동 (6주차)

#### 5.1 AdMob 설정
```dart
// lib/core/services/ad_service.dart
class AdService {
  void showBannerAd() {
    // 배너 광고 표시
  }
  
  void showInterstitialAd() {
    // 전면 광고 표시
  }
}
```

---

## 📝 코딩 컨벤션

### Dart 코딩 스타일
- **변수명**: camelCase (예: `testResult`)
- **클래스명**: PascalCase (예: `TestService`)
- **파일명**: snake_case (예: `test_service.dart`)
- **상수**: UPPER_CASE (예: `MAX_QUESTIONS`)

### 주석 규칙
```dart
/// 테스트 결과를 계산하는 서비스 클래스
class TestService {
  /// ADHD 테스트 점수를 계산합니다.
  /// 
  /// [answers] 사용자의 응답 맵 (문항ID: 점수)
  /// Returns [TestResult] 계산된 결과 객체
  TestResult calculateResult(Map<int, int> answers) {
    // 구현...
  }
}
```

### 폴더 구조 규칙
- 기능별로 폴더 분리
- 최대 3단계 깊이 유지
- index.dart로 export 정리

---

## 🧪 테스트 가이드

### 단위 테스트
```dart
// test/services/test_service_test.dart
void main() {
  group('TestService', () {
    test('should calculate correct score', () {
      // Given
      final service = TestService();
      final answers = {1: 2, 2: 3, 3: 1};
      
      // When
      final result = service.calculateResult(answers);
      
      // Then
      expect(result.totalScore, equals(6));
    });
  });
}
```

### 위젯 테스트
```dart
// test/widgets/test_question_widget_test.dart
void main() {
  testWidgets('should display question text', (tester) async {
    // Given
    const question = Question(
      id: 1,
      text: '테스트 문항입니다',
      category: 'attention_deficit',
      isHighWeight: true,
    );
    
    // When
    await tester.pumpWidget(TestQuestionWidget(question: question));
    
    // Then
    expect(find.text('테스트 문항입니다'), findsOneWidget);
  });
}
```

---

## 🚀 배포 가이드

### Android 배포

#### 1. 키스토어 생성
```bash
keytool -genkey -v -keystore ~/adhd-release-key.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias adhd
```

#### 2. build.gradle 설정
```gradle
android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

#### 3. APK 빌드
```bash
flutter build apk --release
```

### iOS 배포

#### 1. 프로비저닝 프로필 설정
- Apple Developer 계정 필요
- App ID 생성
- 프로비저닝 프로필 다운로드

#### 2. IPA 빌드
```bash
flutter build ipa --release
```

---

## 📋 체크리스트

### 개발 완료 체크리스트
- [ ] 모든 테스트 문항 구현
- [ ] 점수 계산 로직 검증
- [ ] UI/UX 반응형 구현
- [ ] 데이터 저장 기능
- [ ] 광고 연동
- [ ] 오류 처리
- [ ] 접근성 고려
- [ ] 성능 최적화

### 출시 전 체크리스트
- [ ] 베타 테스트 완료
- [ ] 앱스토어 스크린샷 준비
- [ ] 개인정보처리방침 작성
- [ ] 의료 면책조항 추가
- [ ] 마케팅 자료 준비
- [ ] 출시 일정 확정

---

**다음 단계**: [Flutter 프로젝트 생성하기](./FLUTTER_SETUP.md) 