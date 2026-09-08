part of 'reviews_cubit.dart';

@immutable
abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsSuccess extends ReviewsState {
  final List<ReviewModel> reviews;
  ReviewsSuccess(this.reviews);
}

class ReviewsFailure extends ReviewsState {
  final String? errorMessage;
  ReviewsFailure({this.errorMessage});
}
