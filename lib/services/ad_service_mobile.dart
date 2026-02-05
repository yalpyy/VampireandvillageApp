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

void disposeAds() {
  _bannerAd?.dispose();
  _bannerAd = null;
  _isAdLoaded = false;
}
