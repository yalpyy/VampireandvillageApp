import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

// Conditional import for in_app_purchase
import 'purchase_service_stub.dart'
    if (dart.library.io) 'purchase_service_mobile.dart' as purchase_impl;

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  static const String premiumProductId = 'premium_party_pack';

  bool _isPremium = false;
  bool _isAvailable = false;

  bool get isPremium => _isPremium;
  bool get isAvailable => _isAvailable;

  Function(bool)? onPremiumStatusChanged;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('isPremium') ?? false;

    if (kIsWeb) {
      _isAvailable = false;
      return;
    }

    _isAvailable = await purchase_impl.initializePurchases(
      onPurchaseComplete: (success) async {
        if (success) {
          await _setPremium(true);
        }
      },
    );

    if (_isAvailable) {
      await restorePurchases();
    }
  }

  Future<void> _setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', value);
    onPremiumStatusChanged?.call(value);
  }

  Future<bool> purchasePremium() async {
    if (!_isAvailable || kIsWeb) return false;
    return await purchase_impl.purchasePremium(premiumProductId);
  }

  Future<bool> restorePurchases() async {
    if (!_isAvailable || kIsWeb) return false;
    final restored = await purchase_impl.restorePurchases();
    if (restored) {
      await _setPremium(true);
    }
    return restored;
  }

  void dispose() {
    if (!kIsWeb) {
      purchase_impl.disposePurchases();
    }
  }
}
