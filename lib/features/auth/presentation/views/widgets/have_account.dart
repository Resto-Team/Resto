import 'package:flutter/material.dart';
import 'package:resto/core/helpers/extensions.dart';
import 'package:resto/core/localization/app_strings.dart';

class HaveAccount extends StatelessWidget {
  const HaveAccount({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.strings.alreadyHaveAccount,
          style: const TextStyle(color: Colors.white60),
        ),
        TextButton(
          onPressed: () {
            // Navigate to the login screen
            context.pop();
          },
          child: Text(
            context.strings.loginNow,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
