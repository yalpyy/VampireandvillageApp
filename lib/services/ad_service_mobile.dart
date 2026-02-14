// Mobile implementation for AdMob
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_service.dart';

BannerAd? _bannerAd;
bool _isAdLoaded = false;

bool isAdLoaded() => _isAdLoaded;

BannerAd? getBannerAd() => _bannerAd;

Future<void> initializeAds() async {
  await MobileAds.instance.initialize();
}

Future<void> loadBanner() async {
  final adUnitId = Platform.isAndroid
      ? AdConfig.androidBannerAdUnitId
      : AdConfig.iosBannerAdUnitId;

  _bannerAd = BannerAd(
    adUnitId: adUnitId,
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

// Interstitial Ad
InterstitialAd? _interstitialAd;

Future<void> loadInterstitial() async {
  final adUnitId = Platform.isAndroid
      ? AdConfig.androidInterstitialAdUnitId
      : AdConfig.iosInterstitialAdUnitId;

  await InterstitialAd.load(
    adUnitId: adUnitId,
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) => _interstitialAd = ad,
      onAdFailedToLoad: (error) => _interstitialAd = null,
    ),
  );
}

Future<void> showInterstitial() async {
  if (_interstitialAd != null) {
    await _interstitialAd!.show();
    _interstitialAd = null;
    await loadInterstitial();
  }
}

void disposeAds() {
  _bannerAd?.dispose();
  _bannerAd = null;
  _isAdLoaded = false;
  _interstitialAd?.dispose();
  _interstitialAd = null;
}
