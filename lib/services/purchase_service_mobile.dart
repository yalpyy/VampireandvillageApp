// Mobile implementation for in-app purchases
import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

final InAppPurchase _iap = InAppPurchase.instance;
StreamSubscription<List<PurchaseDetails>>? _subscription;
List<ProductDetails> _products = [];
Function(bool)? _onPurchaseComplete;

Future<bool> initializePurchases({
  required Function(bool) onPurchaseComplete,
}) async {
  _onPurchaseComplete = onPurchaseComplete;
  
  final isAvailable = await _iap.isAvailable();
  if (!isAvailable) return false;

  _subscription = _iap.purchaseStream.listen(
    _handlePurchaseUpdates,
    onError: (error) {},
  );

  await _loadProducts();
  return true;
}

Future<void> _loadProducts() async {
  const productIds = {'premium_party_pack'};
  final response = await _iap.queryProductDetails(productIds);
  _products = response.productDetails;
}

void _handlePurchaseUpdates(List<PurchaseDetails> purchases) async {
  for (final purchase in purchases) {
    if (purchase.status == PurchaseStatus.purchased ||
        purchase.status == PurchaseStatus.restored) {
      _onPurchaseComplete?.call(true);
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }
}

Future<bool> purchasePremium(String productId) async {
  if (_products.isEmpty) return false;

  try {
    final product = _products.firstWhere((p) => p.id == productId);
    final purchaseParam = PurchaseParam(productDetails: product);
    return await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  } catch (_) {
    return false;
  }
}

Future<bool> restorePurchases() async {
  await _iap.restorePurchases();
  return true;
}

void disposePurchases() {
  _subscription?.cancel();
}
