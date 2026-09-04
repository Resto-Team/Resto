import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import 'package:resto/core/services/paymob_constants.dart';

class PaymobService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: PaymobConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Creating a payment intention and getting the client_secret
  Future<String> createPaymentIntention({
    required num amount,
    required String currency,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    List<dynamic>? paymentMethods,
  }) async {
    final secretKey = PaymobConstants.secretKey.trim();
    if (secretKey.isEmpty) {
      throw Exception('SECRET_KEY is missing or empty in your .env file!');
    }

    // تجهيز طرق الدفع (Integration IDs)
    List<dynamic> effectiveMethods = paymentMethods ?? [];
    if (effectiveMethods.isEmpty && PaymobConstants.cardIntegrationId.trim().isNotEmpty) {
      final parsedId = int.tryParse(PaymobConstants.cardIntegrationId.trim());
      if (parsedId != null) {
        effectiveMethods = [parsedId];
      }
    }

    if (effectiveMethods.isEmpty) {
      throw Exception(
        'CARD_INTEGRATION_ID is missing in your .env file!\n'
        'Please add CARD_INTEGRATION_ID from Paymob Dashboard -> Developers -> Payment Integrations',
      );
    }

    try {
      // Paymob Intention API requires the amount to be in Cents
      final int amountInCents = (amount * 100).round();

      final payload = {
        'amount': amountInCents,
        'currency': currency,
        'payment_methods': effectiveMethods,
        'items': [
          {
            'name': 'Food Order',
            'amount': amountInCents,
            'description': 'Restaurant Order',
            'quantity': 1,
          }
        ],
        'billing_data': {
          'first_name': firstName.trim().isNotEmpty ? firstName.trim() : 'Customer',
          'last_name': lastName.trim().isNotEmpty ? lastName.trim() : 'User',
          'phone_number': phone.trim().isNotEmpty ? phone.trim() : '01000000000',
          'email': email.trim().isNotEmpty ? email.trim() : 'customer@resto.com',
          'apartment': 'NA',
          'floor': 'NA',
          'street': 'NA',
          'building': 'NA',
          'shipping_method': 'PKG',
          'postal_code': 'NA',
          'city': 'Cairo',
          'country': 'EG',
          'state': 'Cairo',
        },
        'customer': {
          'first_name': firstName.trim().isNotEmpty ? firstName.trim() : 'Customer',
          'last_name': lastName.trim().isNotEmpty ? lastName.trim() : 'User',
          'email': email.trim().isNotEmpty ? email.trim() : 'customer@resto.com',
        },
      };

      developer.log('Paymob Intention Payload: $payload', name: 'Paymob');

      final response = await _dio.post(
        PaymobConstants.intentionEndpoint,
        options: Options(
          headers: {
            'Authorization': 'Token $secretKey',
          },
        ),
        data: payload,
      );

      developer.log('Paymob Response: ${response.data}', name: 'Paymob');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final clientSecret = response.data['client_secret'];
        if (clientSecret != null) {
          return clientSecret.toString();
        }
      }
      throw Exception('Failed to get client_secret from Paymob response');
    } on DioException catch (e) {
      developer.log(
        'Paymob Dio Error: ${e.response?.statusCode} - ${e.response?.data}',
        name: 'Paymob',
      );

      String errorMsg = 'An error occurred while connecting to Paymob';
      final resData = e.response?.data;

      if (resData is Map) {
        if (resData.containsKey('detail')) {
          errorMsg = resData['detail'].toString();
        } else if (resData.containsKey('message')) {
          errorMsg = resData['message'].toString();
        } else {
          // Flatten any field errors like {"amount": ["..."], "payment_methods": ["..."]}
          final errors = resData.entries
              .map((entry) => '${entry.key}: ${entry.value}')
              .join(' | ');
          if (errors.isNotEmpty) errorMsg = errors;
        }
      } else if (resData is String && resData.isNotEmpty) {
        errorMsg = resData;
      } else if (e.message != null && e.message!.isNotEmpty) {
        errorMsg = e.message!;
      }

      throw Exception(errorMsg);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
