import 'package:resto/features/home/domain/entities/product_entity.dart';

abstract class HomeRepo {
  Future<List<ProductEntity>> getProducts({String? categoryId});
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<CategoryEntity>> getCategories();
}
