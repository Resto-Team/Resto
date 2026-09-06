import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:resto/features/home/data/models/reviews_model.dart';
import 'package:resto/features/home/domain/repositories/home_repo.dart';

part 'reviews_state.dart';

class ReviewsCubit extends Cubit<ReviewsState> {
  ReviewsCubit(this.homeRepo) : super(ReviewsInitial());
  final HomeRepo homeRepo;

  Future<void> getReviews(String productId) async {
    emit(ReviewsLoading());
    try {
      final reviews = await homeRepo.getReviews(productId);
      emit(ReviewsSuccess(reviews));
    } catch (e) {
      emit(ReviewsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> addReview(String productId, int rating, String comment) async {
    // Optimistic update would be tricky here because we don't have the new review model immediately
    // from backend or we'd have to emit a new list.
    // Usually, we can just call getReviews again after successful add.
    try {
      await homeRepo.addReview(productId, rating, comment);
      await getReviews(productId);
    } catch (e) {
      emit(ReviewsFailure(errorMessage: e.toString()));
    }
  }

  Future<void> deleteReview(String productId, String reviewId) async {
    try {
      await homeRepo.deleteReview(productId, reviewId);
      await getReviews(productId);
    } catch (e) {
      emit(ReviewsFailure(errorMessage: e.toString()));
    }
  }
}
