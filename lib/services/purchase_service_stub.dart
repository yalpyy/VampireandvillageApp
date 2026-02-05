// Stub implementation for web platform
// In-app purchases are not supported on web

Future<bool> initializePurchases({
  required Function(bool) onPurchaseComplete,
}) async {
  return false;
}

Future<bool> purchasePremium(String productId) async {
  return false;
}

Future<bool> restorePurchases() async {
  return false;
}

void disposePurchases() {}
