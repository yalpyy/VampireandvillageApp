// Mobile implementation for ad widget
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Widget buildAdWidget(dynamic ad) {
  if (ad is BannerAd) {
    return AdWidget(ad: ad);
  }
  return const SizedBox(height: 50);
}
