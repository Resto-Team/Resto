part of 'cart_cubit.dart';

@immutable
sealed class CartState {}

final class CartInitial extends CartState {}

final class GetCartLoadingState extends CartState {}

final class GetCartSuccessState extends CartState {
  final CartEntity cart;
  GetCartSuccessState(this.cart);
}

final class GetCartErrorState extends CartState {
  final String error;
  GetCartErrorState(this.error);
}

final class AddItemToCartLoadingState extends CartState {}

final class AddItemToCartSuccessState extends CartState {
  final CartEntity cart;
  AddItemToCartSuccessState(this.cart);
}

final class AddItemToCartErrorState extends CartState {
  final String error;
  AddItemToCartErrorState(this.error);
}

final class UpdateCartItemLoadingState extends CartState {}

final class UpdateCartItemSuccessState extends CartState {
  final CartEntity cart;
  UpdateCartItemSuccessState(this.cart);
}

final class UpdateCartItemErrorState extends CartState {
  final String error;
  UpdateCartItemErrorState(this.error);
}

final class RemoveItemFromCartLoadingState extends CartState {}

final class RemoveItemFromCartSuccessState extends CartState {
  final CartEntity cart;
  RemoveItemFromCartSuccessState(this.cart);
}

final class RemoveItemFromCartErrorState extends CartState {
  final String error;
  RemoveItemFromCartErrorState(this.error);
}

final class ClearCartLoadingState extends CartState {}

final class ClearCartSuccessState extends CartState {
  final CartEntity cart;
  ClearCartSuccessState(this.cart);
}

final class ClearCartErrorState extends CartState {
  final String error;
  ClearCartErrorState(this.error);
}


final class CreateOrderLoadingState extends CartState {}

final class CreateOrderSuccessState extends CartState {
  final OrderEntity order;
  CreateOrderSuccessState(this.order);
}

final class CreateOrderErrorState extends CartState {
  final String error;
  CreateOrderErrorState(this.error);
}

