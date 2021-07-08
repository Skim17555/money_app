import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:integration_test/integration_test.dart';
import 'package:money_app/profile_info.dart';
import 'package:firebase_core/firebase_core.dart';


void main() {
  group('Testing App Performance Tests', () {
    final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized()
        as IntegrationTestWidgetsFlutterBinding;

    binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

    //wrap into material app for testing
    Widget createWidgetForTesting({Widget? child}){
      return MaterialApp(
        home: child
      );
    }

    //tests scrolling performance from homePage
    testWidgets('Scrolling test', (tester) async {

      //for interstitial ad
      InterstitialAd? _interstitialAd;
      bool _isInterstitialAdReady = false;

      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      //wrap into material app
      await tester.pumpWidget(createWidgetForTesting(child: new ProfileInfo(interstitialAd: _interstitialAd, isInterstitialAdReady: _isInterstitialAdReady)));

      final listFinder = find.byType(SingleChildScrollView);

      await binding.watchPerformance(() async {
        await tester.fling(listFinder, Offset(0, -500), 10000);
        await tester.pumpAndSettle();

        await tester.fling(listFinder, Offset(0, 500), 10000);
        await tester.pumpAndSettle();
      }, reportKey: 'scrolling_summary');
    });
  });

  

}