import 'package:resto/features/cart/domain/entities/cart_entity.dart';
import 'package:resto/features/order_history/domain/entities/order_entity.dart';

abstract class CartRepo {
  Future<CartEntity> getMyCart();

  Future<CartEntity> addItemToCart({
    required String productId,
    required int quantity,
  });

  Future<CartEntity> updateCartItem({
    required String cartItemId,
    required int quantity,
  });

  Future<CartEntity> removeItemFromCart({
    required String cartItemId,
  });

  Future<CartEntity> clearCart();
  
  // Create a new order
  Future<OrderEntity> createOrder({
    required String deliveryAddress,
    required String phone,
    required String paymentMethod,
  });
}
