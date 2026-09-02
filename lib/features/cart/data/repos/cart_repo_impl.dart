import 'package:resto/core/network/api_endpoints.dart';
import 'package:resto/core/network/api_service.dart';
import 'package:resto/features/cart/data/models/cart_model.dart';
import 'package:resto/features/cart/domain/entities/cart_entity.dart';
import 'package:resto/features/cart/domain/repositories/cart_repo.dart';
import 'package:resto/features/order_history/data/models/order_model.dart';
import 'package:resto/features/order_history/domain/entities/order_entity.dart';

class CartRepoImpl implements CartRepo {
  final ApiService apiService;

  CartRepoImpl(this.apiService);

  @override
  Future<CartEntity> getMyCart() async {
    final response = await apiService.get(ApiEndpoints.myCart);

    return CartModel.fromJson(response);
  }

  @override
  Future<CartEntity> addItemToCart({
    required String productId,
    required int quantity,
  }) async {
    final response = await apiService.post(ApiEndpoints.addItemToCart, {
      'productId': productId,
      'product': productId,
      'quantity': quantity,
    });

    return CartModel.fromJson(response);
  }

  @override
  Future<CartEntity> updateCartItem({
    required String cartItemId,
    required int quantity,
  }) async {
    final response = await apiService.put(
      '${ApiEndpoints.updateCartItem}/$cartItemId',
      {
        'quantity': quantity,
      },
    );

    return CartModel.fromJson(response);
  }

  @override
  Future<CartEntity> removeItemFromCart({
    required String cartItemId,
  }) async {
    final response = await apiService.delete(
      '${ApiEndpoints.removeItemFromCart}/$cartItemId'
    );

    return CartModel.fromJson(response);
  }

  @override
  Future<CartEntity> clearCart() async {
    final response = await apiService.delete(ApiEndpoints.clearCart);

    return CartModel.fromJson(response);
  }

  @override
  Future<OrderEntity> createOrder({
    required String deliveryAddress,
    required String phone,
    required String paymentMethod,
  }) async {
    final response = await apiService.post(ApiEndpoints.createOrder, {
      'deliveryAddress': deliveryAddress,
      'phone': phone,
      'paymentMethod': paymentMethod,
    });

    return OrderModel.fromJson(response);
  }
}
