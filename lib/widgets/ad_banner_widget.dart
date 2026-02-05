import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../services/ad_service.dart';

// Conditional import for AdWidget
import 'ad_banner_widget_stub.dart'
    if (dart.library.io) 'ad_banner_widget_mobile.dart' as ad_widget;

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
    if (kIsWeb || !_adService.isAdLoaded || _adService.bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      height: 50,
      child: ad_widget.buildAdWidget(_adService.bannerAd),
    );
  }
}
