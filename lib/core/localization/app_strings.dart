import 'package:flutter/material.dart';
import 'package:resto/core/localization/ar.dart';
import 'package:resto/core/localization/en.dart';

class AppStrings {
  final Locale locale;

  AppStrings(this.locale);

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        AppStrings(const Locale('en'));
  }

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  late final Map<String, String> _localizedValues =
      locale.languageCode == 'ar' ? ar : en;

  String _get(String key) => _localizedValues[key] ?? en[key] ?? key;

  // App
  String get appName => _get('appName');

  // Auth
  String get login => _get('login');
  String get loggingIn => _get('loggingIn');
  String get register => _get('register');
  String get registering => _get('registering');
  String get email => _get('email');
  String get password => _get('password');
  String get confirmPassword => _get('confirmPassword');
  String get name => _get('name');
  String get phone => _get('phone');
  String get dontHaveAccount => _get('dontHaveAccount');
  String get registerNow => _get('registerNow');
  String get alreadyHaveAccount => _get('alreadyHaveAccount');
  String get loginNow => _get('loginNow');
  String get loginFailed => _get('loginFailed');
  String get registerFailed => _get('registerFailed');
  String get registerSuccess => _get('registerSuccess');
  String get pleaseEnterEmail => _get('pleaseEnterEmail');
  String get pleaseEnterPassword => _get('pleaseEnterPassword');
  String get pleaseEnterName => _get('pleaseEnterName');
  String get pleaseEnterPhone => _get('pleaseEnterPhone');
  String get passwordsDoNotMatch => _get('passwordsDoNotMatch');

  // Navigation
  String get home => _get('home');
  String get cart => _get('cart');
  String get myOrders => _get('myOrders');
  String get profile => _get('profile');

  // Home
  String get hello => _get('hello');
  String get search => _get('search');
  String get all => _get('all');
  String get popularNow => _get('popularNow');
  String get categories => _get('categories');
  String get egp => _get('egp');
  String get spicy => _get('spicy');
  String get unavailable => _get('unavailable');

  // Product Details
  String get description => _get('description');
  String get ingredients => _get('ingredients');
  String get reviews => _get('reviews');
  String get addToCart => _get('addToCart');
  String get adding => _get('adding');
  String get addedToCartSuccess => _get('addedToCartSuccess');
  String get productIdMissing => _get('productIdMissing');
  String get postReview => _get('postReview');
  String get writeReview => _get('writeReview');
  String get yourRating => _get('yourRating');

  // Cart
  String get myCart => _get('myCart');
  String get clearCart => _get('clearCart');
  String get cartEmpty => _get('cartEmpty');
  String get cartEmptyDesc => _get('cartEmptyDesc');
  String get refreshCart => _get('refreshCart');
  String get total => _get('total');
  String get items => _get('items');
  String get item => _get('item');
  String get checkout => _get('checkout');
  String get orderSummary => _get('orderSummary');
  String get order => _get('order');
  String get taxes => _get('taxes');
  String get deliveryFees => _get('deliveryFees');
  String get estimatedDeliveryTime => _get('estimatedDeliveryTime');
  String get deliveryTimeValue => _get('deliveryTimeValue');
  String get paymentMethods => _get('paymentMethods');
  String get cashOnDelivery => _get('cashOnDelivery');
  String get creditCard => _get('creditCard');
  String get payWithCard => _get('payWithCard');
  String get placeOrder => _get('placeOrder');
  String get placingOrder => _get('placingOrder');
  String get orderPlacedSuccess => _get('orderPlacedSuccess');
  String get paymentCancelledOrFailed => _get('paymentCancelledOrFailed');

  // Order History
  String get orderHistory => _get('orderHistory');
  String get orderHistorySubtitle => _get('orderHistorySubtitle');
  String get allOrders => _get('allOrders');
  String get ongoing => _get('ongoing');
  String get completed => _get('completed');
  String get cancelled => _get('cancelled');
  String get orderNumber => _get('orderNumber');
  String get noOrdersFound => _get('noOrdersFound');
  String get details => _get('details');
  String get reorder => _get('reorder');
  String get trackOrder => _get('trackOrder');
  String get helpWithOrder => _get('helpWithOrder');
  String get statusDelivered => _get('statusDelivered');
  String get statusPending => _get('statusPending');
  String get statusPreparing => _get('statusPreparing');
  String get statusOutForDelivery => _get('statusOutForDelivery');
  String get statusCancelled => _get('statusCancelled');

  // Profile
  String get account => _get('account');
  String get preferences => _get('preferences');
  String get support => _get('support');
  String get favorites => _get('favorites');
  String get paymentMethodsMenu => _get('paymentMethodsMenu');
  String get darkMode => _get('darkMode');
  String get lightMode => _get('lightMode');
  String get language => _get('language');
  String get arabic => _get('arabic');
  String get english => _get('english');
  String get selectLanguage => _get('selectLanguage');
  String get helpCenter => _get('helpCenter');
  String get about => _get('about');
  String get logout => _get('logout');
  String get logoutConfirmTitle => _get('logoutConfirmTitle');
  String get logoutConfirmMessage => _get('logoutConfirmMessage');
  String get cancel => _get('cancel');
  String get confirm => _get('confirm');
  String get noAddressSet => _get('noAddressSet');

  // Common / Errors
  String get error => _get('error');
  String get retry => _get('retry');
  String get tryAgain => _get('tryAgain');
  String get loading => _get('loading');
  String get success => _get('success');

  // Dynamic formatting helpers
  String totalWithItemsCount(int count) {
    final countStr = count == 1 ? '$count $item' : '$count $items';
    return '$total ($countStr)';
  }

  String orderNumberWithId(String id) => '$orderNumber$id';
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) async {
    return AppStrings(locale);
  }

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

extension AppStringsExtension on BuildContext {
  AppStrings get strings => AppStrings.of(this);
}
