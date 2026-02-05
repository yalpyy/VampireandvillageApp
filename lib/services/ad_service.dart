import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional imports for platform-specific code
import 'ad_service_stub.dart'
    if (dart.library.io) 'ad_service_mobile.dart' as ad_impl;

/// AdMob Configuration
/// Replace these with your actual AdMob IDs before release
class AdConfig {
  // TODO: Replace with your actual AdMob App ID in AndroidManifest.xml and Info.plist
  // Android: ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
  // iOS: ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX

  // Test Ad Unit IDs (use these during development)
  static const String androidBannerAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerAdUnitId = 'ca-app-pub-3940256099942544/2934735716';
}

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isPremium = false;

  bool get isAdLoaded => !kIsWeb && !_isPremium && ad_impl.isAdLoaded();
  dynamic get bannerAd => _isPremium || kIsWeb ? null : ad_impl.getBannerAd();

  Future<void> initialize() async {
    if (kIsWeb) return;
    await ad_impl.initializeAds();
  }

  void setPremiumStatus(bool isPremium) {
    _isPremium = isPremium;
    if (isPremium && !kIsWeb) {
      ad_impl.disposeAds();
    }
  }

  Future<void> loadBannerAd() async {
    if (_isPremium || kIsWeb) return;
    await ad_impl.loadBanner();
  }

  void dispose() {
    if (!kIsWeb) {
      ad_impl.disposeAds();
    }
  }
}
