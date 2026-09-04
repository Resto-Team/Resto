import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/localization/manager/locale_cubit.dart';
import 'package:resto/core/localization/manager/locale_state.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/theme/manager/theme_cubit.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/profile/presentation/views/widgets/language_option_tile.dart';
import 'package:resto/features/profile/presentation/views/widgets/logout_button.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_header.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_menu_item.dart';
import 'package:resto/features/profile/presentation/views/widgets/profile_menu_section.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key, this.onOrdersTap});

  final VoidCallback? onOrdersTap;

  void _showLanguageBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final activeLocale = context.read<LocaleCubit>().currentLocale;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                Gap(20.h),
                Text(
                  context.strings.selectLanguage,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: primaryTextColor,
                  ),
                ),
                Gap(16.h),
                LanguageOptionTile(
                  title: 'English',
                  subtitle: 'English (US)',
                  isSelected: activeLocale.languageCode == 'en',
                  onTap: () {
                    context.read<LocaleCubit>().setLocale(const Locale('en'));
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                Gap(10.h),
                LanguageOptionTile(
                  title: 'العربية',
                  subtitle: 'Arabic (EG)',
                  isSelected: activeLocale.languageCode == 'ar',
                  onTap: () {
                    context.read<LocaleCubit>().setLocale(const Locale('ar'));
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          final userName =
              state is SessionLoaded ? state.userName : 'Guest';
          final phone = state is SessionLoaded ? state.phone : null;
          final address = state is SessionLoaded &&
                  state.address != null &&
                  state.address!.trim().isNotEmpty
              ? state.address!
              : context.strings.noAddressSet;

          return Column(
            children: [
              ProfileHeader(
                userName: userName,
                phone: phone,
                userImage:
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRvts5aHBstDkR8PigS4RmZkbZy78zpZoSuOw&s',
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
                      title: context.strings.account,
                      items: [
                        ProfileMenuItem(
                          icon: Icons.receipt_long_rounded,
                          label: context.strings.myOrders,
                          onTap: onOrdersTap ?? () {},
                        ),
                        ProfileMenuItem(
                          icon: Icons.favorite_border_rounded,
                          label: context.strings.favorites,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: Icons.location_on_outlined,
                          label: address,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: Icons.credit_card_outlined,
                          label: context.strings.paymentMethodsMenu,
                          onTap: () {},
                        ),
                      ],
                    ),
                    Gap(20.h),
                    ProfileMenuSection(
                      title: context.strings.preferences,
                      items: [
                        ProfileMenuItem(
                          icon: isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
                          label: isDark
                              ? context.strings.darkMode
                              : context.strings.lightMode,
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
                          label: context.strings.language,
                          trailing: BlocBuilder<LocaleCubit, LocaleState>(
                            builder: (context, localeState) {
                              final isArabic =
                                  context.read<LocaleCubit>().isArabic;
                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isArabic
                                        ? context.strings.arabic
                                        : context.strings.english,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.darkTextMuted
                                          : AppColors.lightTextMuted,
                                    ),
                                  ),
                                  Gap(4.w),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    size: 20.r,
                                    color: isDark
                                        ? AppColors.darkTextMuted
                                        : AppColors.lightTextMuted,
                                  ),
                                ],
                              );
                            },
                          ),
                          onTap: () => _showLanguageBottomSheet(context),
                        ),
                      ],
                    ),
                    Gap(20.h),
                    ProfileMenuSection(
                      title: context.strings.support,
                      items: [
                        ProfileMenuItem(
                          icon: Icons.help_outline_rounded,
                          label: context.strings.helpCenter,
                          onTap: () {},
                        ),
                        ProfileMenuItem(
                          icon: Icons.info_outline_rounded,
                          label: context.strings.about,
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
          );
        },
      ),
    );
  }
}


