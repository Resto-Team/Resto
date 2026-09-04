import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/home/presentation/manager/products/products_cubit.dart';
import 'package:resto/features/home/presentation/views/widgets/categories_bloc_builder.dart';
import 'package:resto/features/home/presentation/views/widgets/home_app_bar.dart';
import 'package:resto/features/home/presentation/views/widgets/product_bloc_builder.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  String? selectedCategoryId;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectCategory(String? categoryId) {
    setState(() => selectedCategoryId = categoryId);
    context.read<ProductsCubit>().getProducts(categoryId: categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDark
            ? theme.scaffoldBackgroundColor
            : Color.alphaBlend(
                AppColors.primaryColor.withValues(alpha: 0.1),
                Colors.white,
              ),
        body: CustomScrollView(
          clipBehavior: Clip.none,
          slivers: [
            // Header
            BlocBuilder<SessionCubit, SessionState>(
              builder: (context, state) {
                final userName = state is SessionLoaded
                    ? state.userName
                    : 'Loading...';

                return HomeAppBar(
                  userName: userName,
                  userImage:
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvts5aHBstDkR8PigS4RmZkbZy78zpZoSuOw&s',
                  searchController: _searchController,
                  onSearchChanged: (_) {},
                );
              },
            ),

            // Categories
            CategoriesBlocBuilder(
              selectedCategoryId: selectedCategoryId,
              selectCategory: _selectCategory,
            ),

            // Products UI
            ProductBlocBuilder(selectedCategoryId: selectedCategoryId),
          ],
        ),
      ),
    );
  }
}
