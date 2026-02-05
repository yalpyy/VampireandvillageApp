import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static final PurchaseService _instance = PurchaseService._internal();
  factory PurchaseService() => _instance;
  PurchaseService._internal();

  static const String premiumProductId = 'premium_party_pack';
  static const Set<String> _productIds = {premiumProductId};

  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  List<ProductDetails> _products = [];
  bool _isPremium = false;
  bool _isAvailable = false;

  bool get isPremium => _isPremium;
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;

  Function(bool)? onPremiumStatusChanged;

  Future<void> initialize() async {
    _isAvailable = await _iap.isAvailable();
    if (!_isAvailable) return;

    final prefs = await SharedPreferences.getInstance();
    _isPremium = prefs.getBool('isPremium') ?? false;

    _subscription = _iap.purchaseStream.listen(
      _handlePurchaseUpdates,
      onError: (error) {
        // Handle error silently
      },
    );

    await _loadProducts();
    await restorePurchases();
  }

  Future<void> _loadProducts() async {
    final response = await _iap.queryProductDetails(_productIds);
    _products = response.productDetails;
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == premiumProductId) {
          await _setPremium(true);
        }
        if (purchase.pendingCompletePurchase) {
          await _iap.completePurchase(purchase);
        }
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle error
      }
    }
  }

  Future<void> _setPremium(bool value) async {
    _isPremium = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isPremium', value);
    onPremiumStatusChanged?.call(value);
  }

  Future<bool> purchasePremium() async {
    if (!_isAvailable || _products.isEmpty) return false;

    final product = _products.firstWhere(
      (p) => p.id == premiumProductId,
      orElse: () => throw Exception('Product not found'),
    );

    final purchaseParam = PurchaseParam(productDetails: product);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<bool> restorePurchases() async {
    if (!_isAvailable) return false;
    await _iap.restorePurchases();
    return _isPremium;
  }

  void dispose() {
    _subscription?.cancel();
  }
}
