import 'package:resto/core/network/api_endpoints.dart';
import 'package:resto/core/network/api_service.dart';
import 'package:resto/features/home/data/models/products_model.dart';
import 'package:resto/features/home/data/models/reviews_model.dart';
import 'package:resto/features/home/domain/entities/product_entity.dart';
import 'package:resto/features/home/domain/repositories/home_repo.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this.apiService);
  final ApiService apiService;

  @override
  Future<List<ProductEntity>> getProducts({String? categoryId}) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.products,
        param: categoryId != null ? {'category': categoryId} : null,
      );
      return (response as List).map((e) => ProductModel.fromJson(e)).toList();
    } on Exception catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.search,
        param: {'q': query},
      );
      return (response as List).map((e) => ProductModel.fromJson(e)).toList();
    } on Exception catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    try {
      final response = await apiService.get(ApiEndpoints.categories);

      final categories = (response as List)
          .map((e) => CategoryModel.fromJson(e))
          .toList();

      categories.insert(0, CategoryModel(id: null, name: 'All'));

      return categories;
    } on Exception catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  @override
  Future<List<ReviewModel>> getReviews(String productId) async {
    try {
      final response = await apiService.get(ApiEndpoints.reviews(productId));
      return (response as List).map((e) => ReviewModel.fromJson(e)).toList();
    } on Exception catch (e) {
      throw Exception('Failed to load reviews: $e');
    }
  }

  @override
  Future<void> addReview(String productId, int rating, String comment) async {
    try {
      await apiService.post(ApiEndpoints.reviews(productId), {
        'rating': rating,
        'comment': comment,
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteReview(String productId, String reviewId) async {
    try {
      await apiService.delete(ApiEndpoints.deleteReview(productId, reviewId));
    } catch (e) {
      rethrow;
    }
  }
}
