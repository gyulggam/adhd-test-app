import 'dart:io';

/// AdMob 광고 ID 설정
///
/// ⚠️ 중요: AdMob 계정 생성 후 실제 ID로 교체하세요!
///
/// 현재 상태: 테스트 ID 사용 중
/// 실제 배포 전에 반드시 변경 필요!
class AdMobConfig {
  // 🚨 테스트용 ID - 실제 배포 전에 교체 필요!
  static const bool _isTestMode = true; // false로 변경하면 실제 광고 표시

  // ============== 테스트용 ID ==============
  static const String _testAndroidAppId =
      'ca-app-pub-3940256099942544~3347511713';
  static const String _testIosAppId = 'ca-app-pub-3940256099942544~1458002511';
  static const String _testBannerId = 'ca-app-pub-3940256099942544/6300978111';

  // ============== 실제 프로덕션 ID ==============
  // ✅ Android App ID 적용 완료!
  static const String _prodAndroidAppId =
      'ca-app-pub-4307063603855899~2578371306';
  // TODO: iOS 앱 추가 후 iOS App ID로 교체하세요
  static const String _prodIosAppId =
      'ca-app-pub-4307063603855899~YOUR_IOS_APP_ID';
  // TODO: 배너 광고 단위 생성 후 실제 ID로 교체하세요
  static const String _prodBannerId =
      'ca-app-pub-4307063603855899/YOUR_BANNER_AD_UNIT_ID';

  // ============== 현재 사용할 ID 반환 ==============

  /// 현재 플랫폼의 App ID 반환
  static String get appId {
    if (_isTestMode) {
      return Platform.isAndroid ? _testAndroidAppId : _testIosAppId;
    } else {
      return Platform.isAndroid ? _prodAndroidAppId : _prodIosAppId;
    }
  }

  /// 배너 광고 ID 반환
  static String get bannerId {
    return _isTestMode ? _testBannerId : _prodBannerId;
  }

  /// 현재 테스트 모드인지 확인
  static bool get isTestMode => _isTestMode;

  // ============== AdMob 계정 설정 가이드 ==============
  ///
  /// 🔧 실제 광고로 전환하는 방법:
  ///
  /// 1. Google AdMob (https://admob.google.com) 계정 생성
  /// 2. 새 앱 추가:
  ///    - 앱 이름: "ADHD 자가진단 테스트"
  ///    - 패키지명: "com.jinsu.adhdtest"
  /// 3. 광고 단위 생성:
  ///    - 배너 광고 단위 추가
  ///    - 광고 단위 이름: "결과화면_배너"
  /// 4. 생성된 ID를 위의 _prod... 변수들에 복사
  /// 5. _isTestMode를 false로 변경
  /// 6. AndroidManifest.xml과 Info.plist도 업데이트
  ///
  /// ⚠️ 주의사항:
  /// - 테스트 중에는 절대 실제 광고를 클릭하지 마세요! (계정 정지 위험)
  /// - 실제 배포 전에만 실제 ID로 교체하세요
  /// - AdMob 정책을 반드시 준수하세요
  ///
}
