import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/theme/manager/theme_cubit.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_header.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_menu_item.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_menu_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, this.onOrdersTap});

  final VoidCallback? onOrdersTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? theme.scaffoldBackgroundColor
          : Color.alphaBlend(
              AppColors.primaryColor.withValues(alpha: 0.1),
              Colors.white,
            ),
      body: Column(
        children: [
          BlocBuilder<SessionCubit, SessionState>(
            builder: (context, state) {
              final userName = state is SessionLoaded
                  ? state.userName
                  : 'Guest';
              final phone = state is SessionLoaded ? state.phone : null;

              return ProfileHeader(
                userName: userName,
                phone: phone,
                userImage:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvts5aHBstDkR8PigS4RmZkbZy78zpZoSuOw&s',
              );
            },
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 24.h,
                bottom: 120.h,
              ),
              children: [
                ProfileMenuSection(
                  title: 'ACCOUNT',
                  items: [
                    ProfileMenuItem(
                      icon: Icons.receipt_long_rounded,
                      label: 'My Orders',
                      onTap: onOrdersTap ?? () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.favorite_border_rounded,
                      label: 'Favorites',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.location_on_outlined,
                      label: 'Addresses',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.credit_card_outlined,
                      label: 'Payment Methods',
                      onTap: () {},
                    ),
                  ],
                ),
                Gap(20.h),
                ProfileMenuSection(
                  title: 'PREFERENCES',
                  items: [
                    ProfileMenuItem(
                      icon: isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      label: isDark ? 'Dark Mode' : 'Light Mode',
                      trailing: Switch.adaptive(
                        value: isDark,
                        onChanged: (_) {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        activeTrackColor: AppColors.primaryLight,
                      ),
                      onTap: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.language_rounded,
                      label: 'Language',
                      onTap: () {},
                    ),
                  ],
                ),
                Gap(20.h),
                ProfileMenuSection(
                  title: 'SUPPORT',
                  items: [
                    ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help Center',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About',
                      onTap: () {},
                    ),
                  ],
                ),
                Gap(28.h),
                const LogoutButton(),
                Gap(20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
