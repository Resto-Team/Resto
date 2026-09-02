import 'package:resto/features/cart/data/models/cart_item_model.dart';
import 'package:resto/features/cart/domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel({
    super.id,
    super.user,
    super.items,
    super.totalPrice,
    super.status,
    super.deliveryAddress,
    super.phone,
    super.paymentMethod,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id']?.toString() ?? json['id']?.toString(),
      user: json['user']?.toString(),
      items: (json['items'] as List?)
          ?.map((item) => CartItemModel.fromJson(item))
          .toList(),
      totalPrice: json['totalPrice'] as double?,
      status: json['status']?.toString(),
      deliveryAddress: json['deliveryAddress']?.toString(),
      phone: json['phone']?.toString(),
      paymentMethod: json['paymentMethod']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }
}