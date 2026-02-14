// Stub implementation for web platform
// AdMob is not supported on web

bool isAdLoaded() => false;

dynamic getBannerAd() => null;

Future<void> initializeAds() async {}

Future<void> loadBanner() async {}

Future<void> loadInterstitial() async {}

Future<void> showInterstitial() async {}

void disposeAds() {}
