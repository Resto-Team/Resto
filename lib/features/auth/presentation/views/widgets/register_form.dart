import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:gap/gap.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/core/widgets/custom_button.dart';
import 'package:resto/core/widgets/custom_text_field.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.onSubmit,
  });

  final bool isLoading;
  final void Function(String name, String phone, String email, String password)
  onSubmit;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextfield(
            hint: context.strings.name,
            isPassword: false,
            controller: _nameController,
          ),

          Gap(20.h),

          CustomTextfield(
            hint: context.strings.email,
            isPassword: false,
            controller: _emailController,
          ),

          Gap(20.h),
          CustomTextfield(
            hint: context.strings.phone,
            isPassword: false,
            controller: _phoneController,
          ),

          Gap(20.h),

          CustomTextfield(
            hint: context.strings.password,
            isPassword: true,
            controller: _passwordController,
          ),

          Gap(20.h),

          CustomTextfield(
            hint: context.strings.confirmPassword,
            isPassword: true,
            controller: _confirmPasswordController,
          ),

          Gap(20.h),

          CustomButton(
            text: widget.isLoading ? context.strings.registering : context.strings.register,
            onTap: widget.isLoading ? null : _submit,
            textColor: Colors.white,
            color: Colors.white.withValues(alpha: 0.40),
          ),
        ],
      ),
    );
  }
}
