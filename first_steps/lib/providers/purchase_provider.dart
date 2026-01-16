import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Provider for managing RevenueCat purchases
class PurchaseProvider extends ChangeNotifier {
  static const String _proEntitlementId = 'pro';
  static const String _revenueCatApiKey = 'REVENUECAT_PUBLIC_API_KEY';

  bool _isPro = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;

  PurchaseProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    try {
      await Purchases.configure(
        PurchasesConfiguration(_revenueCatApiKey),
      );
      _isInitialized = true;
      await _refreshCustomerInfo();
    } catch (e) {
      _isInitialized = false;
      if (kDebugMode) {
        debugPrint('RevenueCat init failed: $e');
      }
    }
  }

  Future<void> _refreshCustomerInfo() async {
    try {
      final info = await Purchases.getCustomerInfo();
      _isPro = info.entitlements.all[_proEntitlementId]?.isActive ?? false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to refresh customer info: $e');
      }
    }
  }

  Future<void> purchasePro() async {
    _isLoading = true;
    notifyListeners();
    try {
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        throw Exception('No available packages');
      }

      final package = currentOffering.availablePackages.first;
      final customerInfo = await Purchases.purchasePackage(package);
      _isPro = customerInfo.entitlements.all[_proEntitlementId]?.isActive ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Purchase failed: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> restorePurchases() async {
    _isLoading = true;
    notifyListeners();
    try {
      final info = await Purchases.restorePurchases();
      _isPro = info.entitlements.all[_proEntitlementId]?.isActive ?? false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Restore failed: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
