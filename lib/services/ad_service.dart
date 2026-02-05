import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';

/// AdMob Configuration
/// Replace these with your actual AdMob IDs before release
class AdConfig {
  // TODO: Replace with your actual AdMob App ID in AndroidManifest.xml and Info.plist
  // Android: ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX
  // iOS: ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX

  // Test Ad Unit IDs (use these during development)
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Android test banner
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // iOS test banner
    }
    throw UnsupportedError('Unsupported platform');
  }

  // TODO: Replace with your production Ad Unit IDs
  // static const String androidBannerAdUnitId = 'ca-app-pub-YOUR_ID/YOUR_UNIT_ID';
  // static const String iosBannerAdUnitId = 'ca-app-pub-YOUR_ID/YOUR_UNIT_ID';
}

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isPremium = false;

  bool get isAdLoaded => _isAdLoaded && !_isPremium;
  BannerAd? get bannerAd => _isPremium ? null : _bannerAd;

  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  void setPremiumStatus(bool isPremium) {
    _isPremium = isPremium;
    if (isPremium) {
      dispose();
    }
  }

  Future<void> loadBannerAd() async {
    if (_isPremium) return;

    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          _isAdLoaded = false;
          ad.dispose();
          _bannerAd = null;
        },
      ),
    );

    await _bannerAd?.load();
  }

  void dispose() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _isAdLoaded = false;
  }
}
