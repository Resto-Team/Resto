import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/widgets/custom_button.dart';
import 'package:resto/core/widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.isLoading, required this.onSubmit});

  final bool isLoading;
  final void Function(String email, String password) onSubmit;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_emailController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextfield(
            hint: context.strings.email,
            isPassword: false,
            controller: _emailController,
          ),

          Gap(20.h),

          CustomTextfield(
            hint: context.strings.password,
            isPassword: true,
            controller: _passwordController,
          ),

          Gap(20.h),

          CustomButton(
            text: widget.isLoading ? context.strings.loggingIn : context.strings.login,
            onTap: widget.isLoading ? null : _submit,
            textColor: Colors.white,
            color: Colors.white.withValues(alpha: 0.40),
          ),
        ],
      ),
    );
  }
}
