import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resto/core/helpers/extensions.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/routing/routes.dart';
import 'package:resto/core/theme/app_colors.dart';
import 'package:resto/core/widgets/custom_button.dart';
import 'package:resto/features/auth/presentation/manager/session/session_cubit.dart';
import 'package:resto/features/profile/presentation/views/widgets/logout_sheet.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _confirmLogout(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return const LogoutSheet();
      },
    );

    if (confirmed != true || !context.mounted) return;

    await context.read<SessionCubit>().logout();

    if (context.mounted) {
      context.pushReplacementNamed(Routes.loginView);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomButton(
      text: context.strings.logout,
      color: isDark
          ? Colors.red.shade900.withValues(alpha: 0.3)
          : Colors.red.shade50,
      textColor: isDark ? Colors.red.shade300 : Colors.red.shade700,
      onTap: () => _confirmLogout(context),
    );
  }
}
