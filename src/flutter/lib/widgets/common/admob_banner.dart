import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/admob_config.dart';

/// AdMob 배너 광고 위젯
class AdMobBanner extends StatefulWidget {
  const AdMobBanner({super.key});

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdMobConfig.bannerId, // 설정 파일에서 ID 가져오기
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
          if (AdMobConfig.isTestMode) {
            print('🧪 테스트 광고 로딩 완료: ${AdMobConfig.bannerId}');
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('❌ AdMob 배너 광고 로딩 실패: $error');
          if (AdMobConfig.isTestMode) {
            print('🧪 테스트 모드에서 광고 로딩 실패 - 정상적인 현상일 수 있음');
          }
          ad.dispose();
        },
        onAdOpened: (ad) => print('📂 AdMob 배너 광고 열림'),
        onAdClosed: (ad) => print('❌ AdMob 배너 광고 닫힘'),
      ),
      request: const AdRequest(),
    );

    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null) {
      // 광고가 로딩 중일 때 보여줄 placeholder
      return Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.grey.shade400,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AdMobConfig.isTestMode ? '테스트 광고 로딩 중...' : '광고 로딩 중...',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // 광고 라벨
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  AdMobConfig.isTestMode ? 'TEST AD' : 'AD',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 8),

          // 실제 AdMob 배너 광고
          Container(
            alignment: Alignment.center,
            child: AdWidget(ad: _bannerAd!),
            width: _bannerAd!.size.width.toDouble(),
            height: _bannerAd!.size.height.toDouble(),
          ),
        ],
      ),
    );
  }
}
