import 'package:flutter/material.dart';
import 'package:resto/core/helpers/extensions.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/routing/routes.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.strings.dontHaveAccount,
          style: const TextStyle(color: Colors.white60),
        ),
        TextButton(
          onPressed: () {
            // Navigate to the sign-up screen
            context.pushNamed(Routes.registerView);
          },
          child: Text(
            context.strings.registerNow,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
