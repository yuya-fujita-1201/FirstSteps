import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service for managing AdMob interstitial ads
class AdService {
  static final AdService _instance = AdService._internal();

  factory AdService() => _instance;

  AdService._internal();

  static const int _showInterval = 3;
  int _showCounter = 0;
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return kReleaseMode
          ? 'YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID'
          : 'ca-app-pub-3940256099942544/1033173712';
    }
    if (Platform.isIOS) {
      return kReleaseMode
          ? 'YOUR_IOS_INTERSTITIAL_AD_UNIT_ID'
          : 'ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }

  void loadInterstitialAd() {
    if (_isLoading || interstitialAdUnitId.isEmpty) return;
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
          _interstitialAd?.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          if (kDebugMode) {
            debugPrint('Interstitial load failed: $error');
          }
          _isLoading = false;
        },
      ),
    );
  }

  void showInterstitialAd() {
    _showCounter += 1;
    if (_showCounter % _showInterval != 0) return;
    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitialAd();
      return;
    }
    ad.show();
    _interstitialAd = null;
  }
}
