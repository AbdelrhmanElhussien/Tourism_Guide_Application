import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
import 'package:tourist_app/features/auth/cubit/auth_states.dart';
import 'package:tourist_app/features/auth/signup/cubit/register_view_model.dart';
import 'package:tourist_app/features/auth/widgets/app_text_field.dart';
import 'package:tourist_app/features/auth/widgets/google_icon.dart';
import 'package:tourist_app/features/auth/widgets/social_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  final RegisetrViewModel viewModel = getIt<RegisetrViewModel>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalityController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      viewModel.register(
        email: _emailController.text,
        password: _passwordController.text,
        fullName: _nameController.text,
        confirmPassword: _confirmController.text,
        phoneNumber: _phoneController.text,
        nationality: _nationalityController.text,
      );
      debugPrint('Name   : ${_nameController.text}');
      debugPrint('Email  : ${_emailController.text}');
      debugPrint('Phone  : ${_phoneController.text}');
      debugPrint('Nationality: ${_nationalityController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    return BlocListener<RegisetrViewModel, AuthState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is AuthLoadingState) {
          DialogeUtils.showLoading(context: context, text: "waiting_msg".tr());
        } else if (state is AuthErrorState) {
          DialogeUtils.hideLoading(context: context);
          DialogeUtils.showMassage(
            context: context,
            masseage: state.errorMsg.message,
            posActionName: "ok_action".tr(),
            title: "error_title".tr(),
          );
        } else if (state is AuthSuccessState) {
          DialogeUtils.hideLoading(context: context);
          DialogeUtils.showMassage(
            context: context,
            masseage: "signin_success_msg".tr(),
            posActionName: "ok_action".tr(),
            title: "success_title".tr(),
            posFun: () {
              Navigator.pushReplacementNamed(context, AppRoutes.HomeRouteName);
            },
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ──────────────────────────
                  Text(
                    'create_account'.tr(),
                    style: themeProvider.apptheme == ThemeMode.dark
                        ? AppStyles.semiBold30Bagi
                        : AppStyles.semiBold30Black,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'start_exploring_egypt'.tr(),
                    style: themeProvider.apptheme == ThemeMode.dark
                        ? AppStyles.regular16lightBlue
                        : AppStyles.regular16balck,
                  ),
                  const SizedBox(height: 28),

                  // ── Fields ──────────────────────────
                  AppTextField(
                    controller: _nameController,
                    label: 'full_name'.tr(),
                    hint: 'enter_name_hint'.tr(),
                    prefixIcon: Icons.person_outline,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'please_enter_name'.tr()
                        : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _emailController,
                    label: 'email'.tr(),
                    hint: 'enter_email_hint'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'please_enter_email'.tr();
                      }
                      if (!v.contains('@')) return 'please_enter_valid_email'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _phoneController,
                    label: 'phone_number'.tr(),
                    hint: 'enter_phone_number'.tr(),
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'please_enter_phone'.tr()
                        : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _nationalityController,
                    label: 'nationality'.tr(),
                    hint: 'enter_nationality'.tr(),
                    prefixIcon: Icons.flag_outlined,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'please_enter_nationality'.tr()
                        : null,
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _passwordController,
                    label: 'password'.tr(),
                    hint: 'enter_password_hint'.tr(),
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'please_enter_password'.tr();
                      if (v.length < 8) return 'min_8_characters'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _confirmController,
                    label: 'confirm_password'.tr(),
                    hint: 're_enter_password'.tr(),
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'please_confirm_password'.tr();
                      }
                      if (v != _passwordController.text) {
                        return 'password_not_match'.tr();
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  // ── Sign Up button ───────────────────
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC9A84C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'sign_up'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Divider ──────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.blueColor
                              : AppColors.blackColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or_divider'.tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: themeProvider.apptheme == ThemeMode.dark
                                ? AppColors.blueColor
                                : AppColors.blackColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.blueColor
                              : AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Social buttons ───────────────────
                  SocialButton(
                    icon: const GoogleIcon(),
                    label: 'continue_google'.tr(),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 12),
                  SocialButton(
                    icon: const Icon(
                      Icons.facebook,
                      color: Color(0xFF1877F2),
                      size: 22,
                    ),
                    label: 'continue_facebook'.tr(),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 24),

                  // ── Sign In link ─────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'already_have_account'.tr() + ' ',
                        style: TextStyle(
                          fontSize: 13,
                          color: themeProvider.apptheme == ThemeMode.dark
                              ? AppColors.blueColor
                              : AppColors.blackColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'sign_in'.tr(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFC9A84C),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
