import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/onboarding/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const AdhdCheckApp());
}

class AdhdCheckApp extends StatelessWidget {
  const AdhdCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '어? hoxy ADHD인가?',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9800)),
        useMaterial3: true,
        fontFamily: 'Pretendard', // 나중에 한글 폰트 추가
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
    );
  }
}
