import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto/features/home/presentation/manager/reviews/reviews_cubit.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';

class Review {
  const Review({
    required this.id,
    required this.name,
    required this.rating,
    required this.comment,
    this.isMine = false,
  });

  final String id;
  final String name;
  final int rating;
  final String comment;
  final bool isMine;
}

class ProductReviewsSection extends StatefulWidget {
  const ProductReviewsSection({super.key, required this.productId});

  final String productId;

  @override
  State<ProductReviewsSection> createState() => _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends State<ProductReviewsSection> {
  final _commentController = TextEditingController();
  int _newRating = 5;
  List<Review> _cachedReviews = [];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitReview() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) return;

    context.read<ReviewsCubit>().addReview(
      widget.productId,
      _newRating,
      comment,
    );

    setState(() {
      _commentController.clear();
      _newRating = 5;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sessionState = context.read<SessionCubit>().state;
    final currentUserName = sessionState is SessionLoaded ? sessionState.userName : null;

    return BlocConsumer<ReviewsCubit, ReviewsState>(
      listener: (context, state) {
        if (state is ReviewsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'An error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isLoading = state is ReviewsLoading;

        if (state is ReviewsSuccess) {
          _cachedReviews = state.reviews
              .map(
                (r) => Review(
                  id: r.id,
                  name: r.user.name,
                  rating: r.rating,
                  comment: r.comment,
                  isMine: currentUserName != null && r.user.name == currentUserName,
                ),
              )
              .toList();
        }

        final allReviews = _cachedReviews;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: context.strings.reviews,
              size: 16,
              weight: FontWeight.w600,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.primaryColor,
            ),

            Gap(12.h),

            _AddReviewCard(
              rating: _newRating,
              controller: _commentController,
              onRatingChanged: (rating) => setState(() => _newRating = rating),
              onSubmit: _submitReview,
            ),

            Gap(16.h),

            if (isLoading && _cachedReviews.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (_cachedReviews.isEmpty)
              const Center(child: Text('No reviews yet.'))
            else
              for (final review in allReviews) _ReviewTile(review: review, productId: widget.productId),
          ],
        );
      },
    );
  }
}

class _AddReviewCard extends StatelessWidget {
  const _AddReviewCard({
    required this.rating,
    required this.controller,
    required this.onRatingChanged,
    required this.onSubmit,
  });

  final int rating;
  final TextEditingController controller;
  final ValueChanged<int> onRatingChanged;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xffF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: AppColors.darkBorder) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StarRow(rating: rating, onChanged: onRatingChanged),

          Gap(10.h),

          TextField(
            controller: controller,
            minLines: 1,
            maxLines: 3,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            decoration: InputDecoration(
              hintText: context.strings.writeReview,
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.darkTextMuted
                    : AppColors.lightTextMuted,
                fontSize: 14,
              ),
              filled: true,
              fillColor: isDark ? AppColors.darkSurfaceVariant : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isDark
                    ? const BorderSide(color: AppColors.darkBorder)
                    : BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: isDark
                    ? const BorderSide(color: AppColors.darkBorder)
                    : BorderSide.none,
              ),
            ),
          ),

          Gap(10.h),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSubmit,
              child: CustomText(
                text: context.strings.postReview,
                size: 13,
                weight: FontWeight.w600,
                color: isDark ? AppColors.primaryLight : AppColors.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  const _ReviewTile({required this.review, required this.productId});

  final Review review;
  final String productId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primary = isDark ? AppColors.primaryLight : AppColors.primaryColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: primary.withValues(alpha: isDark ? 0.25 : 0.15),
            child: CustomText(
              text: review.name.isNotEmpty ? review.name[0] : '?',
              size: 14,
              weight: FontWeight.w700,
              color: primary,
            ),
          ),

          const Gap(10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      text: review.name,
                      size: 14,
                      weight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    const Gap(8),
                    _StarRow(rating: review.rating, size: 14),
                  ],
                ),

                const Gap(4),

                Text(
                  review.comment,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (review.isMine)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              onPressed: () {
                context.read<ReviewsCubit>().deleteReview(productId, review.id);
              },
            ),
        ],
      ),
    );
  }
}

/// Row of 5 stars. Pass [onChanged] to make it tappable (rating input),
/// leave it null to render a read-only rating.
class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating, this.onChanged, this.size = 22});

  final int rating;
  final ValueChanged<int>? onChanged;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating;
        final star = Icon(
          filled ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: size,
        );

        if (onChanged == null) return star;

        return GestureDetector(onTap: () => onChanged!(index + 1), child: star);
      }),
    );
  }
}
