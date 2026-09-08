import 'package:resto/features/home/domain/entities/product_entity.dart';
import 'package:resto/features/home/data/models/reviews_model.dart';

abstract class HomeRepo {
  Future<List<ProductEntity>> getProducts({String? categoryId});
  Future<List<ProductEntity>> searchProducts(String query);
  Future<List<CategoryEntity>> getCategories();
  Future<List<ReviewModel>> getReviews(String productId);
  Future<void> addReview(String productId, int rating, String comment);
  Future<void> deleteReview(String productId, String reviewId);
}
