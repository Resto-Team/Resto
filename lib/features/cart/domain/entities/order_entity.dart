import 'package:resto/features/cart/domain/entities/cart_item_entity.dart';

class OrderEntity {
  final String? id;
  final String? user;
  final List<CartItemEntity>? items;
  final double? totalPrice;
  final String? status;
  final String? deliveryAddress;
  final String? phone;
  final String? paymentMethod;
  final String? createdAt;
  final String? updatedAt;

  const OrderEntity({
    this.id,
    this.user,
    this.items,
    this.totalPrice,
    this.status,
    this.deliveryAddress,
    this.phone,
    this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });
}
