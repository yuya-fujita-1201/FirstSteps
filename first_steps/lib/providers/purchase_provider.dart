import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

/// Provider for managing RevenueCat purchases
class PurchaseProvider extends ChangeNotifier {
  static const String _proEntitlementId = 'pro';
  static const String _revenueCatApiKey = 'test_azAFcRLtJBNJzDZfLyknYmiryWg';
  static const bool _useMockPurchases = true;
  static const List<String> _mockPlanIds = [
    'weekly',
    'monthly',
    'annual',
  ];

  bool _isPro = false;
  bool _isInitialized = false;
  bool _isLoading = false;

  bool get isPro => _isPro;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  bool get isMockMode => _useMockPurchases;
  List<String> get mockPlanIds => List.unmodifiable(_mockPlanIds);

  PurchaseProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    try {
      if (_useMockPurchases) {
        _isInitialized = true;
        notifyListeners();
        return;
      }
      await Purchases.setLogLevel(LogLevel.debug);
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
      if (_useMockPurchases) {
        return;
      }
      final info = await Purchases.getCustomerInfo();
      _isPro = info.entitlements.all[_proEntitlementId]?.isActive ?? false;
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Failed to refresh customer info: $e');
      }
    }
  }

  Future<void> purchasePro({String? planId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (_useMockPurchases) {
        await Future.delayed(const Duration(milliseconds: 300));
        _isPro = true;
        return;
      }
      final offerings = await Purchases.getOfferings();
      final currentOffering = offerings.current;
      if (currentOffering == null || currentOffering.availablePackages.isEmpty) {
        throw Exception('No available packages');
      }

      final package = currentOffering.availablePackages.first;
      final result = await Purchases.purchasePackage(package);
      _isPro = result.customerInfo.entitlements.all[_proEntitlementId]?.isActive ?? false;
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
      if (_useMockPurchases) {
        await Future.delayed(const Duration(milliseconds: 300));
        _isPro = true;
        return;
      }
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
