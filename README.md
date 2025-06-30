# 🧠 ADHD Check - 성인 ADHD 자가진단 앱

> 성인 ADHD 증상으로 고민하는 사람들을 위한 간편하고 신뢰할 수 있는 자가진단 도구

## 📱 프로젝트 개요

**ADHD Check**는 WHO ASRS-v1.1을 기반으로 한 성인 ADHD 자가진단 앱입니다. Flutter로 개발되어 Android와 iOS에서 동시에 사용할 수 있습니다.

### ✨ 주요 기능
- 🔍 **과학적 진단 도구**: WHO ASRS-v1.1 기반 18문항 테스트
- ⚡ **즉시 결과**: 5-7분 만에 완료하고 바로 결과 확인
- 📊 **상세 분석**: 주의력 결핍과 과활동성 각각의 점수 제공
- 💡 **맞춤형 조언**: 개인 결과에 따른 대처법 및 생활 팁
- 🏥 **전문가 연결**: 필요시 전문의료기관 정보 제공

## 🎯 타겟 사용자

- **직장인**: 업무 집중력 저하로 고민하는 20-40대
- **대학생**: 학습 집중 어려움을 겪는 학생들
- **일반인**: ADHD 증상이 의심되어 확인하고 싶은 성인들

## 🛠 기술 스택

### Frontend
- **Flutter** 3.16.0+
- **Dart** 3.2.0+

### Backend & Database
- **SQLite** (로컬 데이터)
- **Firebase** (백업 및 분석)

### 서비스
- **Google AdMob** (광고)
- **Firebase Analytics** (사용자 분석)
- **Firebase Crashlytics** (오류 추적)

## 📁 프로젝트 구조

```
adhd-test-app/
├── docs/                  # 문서들
│   ├── PRD.md            # Product Requirements Document
│   ├── API.md            # API 문서
│   └── DESIGN.md         # 디자인 가이드
├── design/               # UI/UX 디자인 파일
├── src/flutter/         # Flutter 앱 소스코드
├── assets/              # 앱 리소스
│   ├── images/          # 이미지 파일
│   └── fonts/           # 폰트 파일
├── research/            # 시장조사 및 리서치
└── marketing/           # 마케팅 자료
```

## 🚀 빠른 시작

### 전제 조건
- Flutter SDK 3.16.0 이상
- Dart SDK 3.2.0 이상
- Android Studio / VS Code
- iOS 개발 시 Xcode (Mac 필요)

### 설치

1. **저장소 클론**
```bash
git clone https://github.com/your-username/adhd-test-app.git
cd adhd-test-app
```

2. **의존성 설치**
```bash
cd src/flutter
flutter pub get
```

3. **앱 실행**
```bash
flutter run
```

## 📋 개발 일정

- [x] **Week 1-2**: 기획 및 설계
- [ ] **Week 3-6**: 개발
- [ ] **Week 7-8**: 테스트 및 최적화
- [ ] **Week 9**: 출시 준비

## 🧪 테스트

```bash
# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test/
```

## 📊 진행 상황

### v1.0 MVP 기능
- [ ] 온보딩 화면
- [ ] ADHD 테스트 (18문항)
- [ ] 결과 분석 및 표시
- [ ] 로컬 데이터 저장
- [ ] 광고 연동
- [ ] 기본 정보 페이지

### 향후 계획
- v1.1: 테스트 히스토리 및 비교
- v1.2: 프리미엄 구독 기능
- v2.0: 커뮤니티 및 AI 기능

## ⚖️ 법적 고지사항

⚠️ **중요**: 본 앱은 의학적 진단을 대체할 수 없습니다. 정확한 ADHD 진단은 반드시 정신과 전문의와 상담하시기 바랍니다.

## 📞 연락처

- **개발자**: 김진수
- **이메일**: [your-email@example.com]
- **GitHub**: [@your-username](https://github.com/your-username)

## 📜 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

---

⭐ **이 프로젝트가 도움이 되었다면 스타를 눌러주세요!** 