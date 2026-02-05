import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../services/ad_service.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _adService.loadBannerAd();
  }

  @override
  Widget build(BuildContext context) {
    if (!_adService.isAdLoaded || _adService.bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      height: 50,
      child: AdWidget(ad: _adService.bannerAd!),
    );
  }
}
