import 'package:flutter_dotenv/flutter_dotenv.dart';

class PaymobConstants {
  // Paymob API Base URL
  static const String baseUrl = 'https://accept.paymob.com/';
  static const String intentionEndpoint = 'v1/intention/';

  // Keys of Paymob Test Mode
  // Secret Key
  static String get secretKey => (dotenv.env['SECRET_KEY'] ?? '').trim();

  // Public Key
  static String get publicKey => (dotenv.env['PUBLIC_KEY'] ?? '').trim();

  // Card Integration ID from .env
  static String get cardIntegrationId => (dotenv.env['CARD_INTEGRATION_ID'] ?? '').trim();

  // رابط صفحة الدفع الموحدة (Unified Checkout URL)
  static String getUnifiedCheckoutUrl(String clientSecret) {
    return 'https://eg.checkout.paymob.com/?publicKey=$publicKey&clientSecret=${clientSecret.trim()}';
  }
}
