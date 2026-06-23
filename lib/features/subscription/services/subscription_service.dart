import 'dart:io';

import 'package:in_app_purchase/in_app_purchase.dart';

import '../constants/subscription_products.dart';

enum PurchasePlatform { apple, google }

class SubscriptionService {
  SubscriptionService._internal();

  static final SubscriptionService instance = SubscriptionService._internal();

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  Future<void> purchasePremium({PurchasePlatform? platform}) async {
    final targetPlatform = platform ?? _defaultPlatform();
    if (targetPlatform == null) {
      throw Exception('Subscriptions are not supported on this platform.');
    }

    final isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      throw Exception('In-app purchases are unavailable on this device.');
    }

    final productId = _productIdForPlatform(targetPlatform);
    final response = await _inAppPurchase.queryProductDetails({productId});

    if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
      throw Exception('Unable to find subscription product ($productId).');
    }

    final productDetails = response.productDetails.first;
    final purchaseParam = PurchaseParam(productDetails: productDetails);

    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  PurchasePlatform? _defaultPlatform() {
    if (Platform.isIOS) return PurchasePlatform.apple;
    if (Platform.isAndroid) return PurchasePlatform.google;
    return null;
  }

  String _productIdForPlatform(PurchasePlatform platform) {
    switch (platform) {
      case PurchasePlatform.apple:
        return SubscriptionProducts.premiumAppleProductId;
      case PurchasePlatform.google:
        return SubscriptionProducts.premiumGoogleProductId;
    }
  }
}


