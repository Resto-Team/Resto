import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:resto/features/home/domain/entities/product_entity.dart';
import 'package:resto/features/home/domain/repositories/home_repo.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this.homeRepo) : super(ProductsInitial());
  final HomeRepo homeRepo;

  Future<void> getProducts({String? categoryId}) async {
    emit(ProductsLoading());
    try {
      final products = await homeRepo.getProducts(categoryId: categoryId);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> searchProducts(String query) async {
    emit(ProductsLoading());
    try {
      final products = await homeRepo.searchProducts(query);
      emit(ProductsSuccess(products));
    } catch (e) {
      emit(ProductsFailure(errorMessage: e.toString()));
    }
  }
}
