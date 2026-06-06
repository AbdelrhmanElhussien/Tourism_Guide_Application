import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_styles.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/auth_states.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/signUp/cubit/regisetrViewModel.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/AppTextField.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/GoogleIcon.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/SocialButton.dart';

// ─────────────────────────────────────────────
//  sign up Screen
// ─────────────────────────────────────────────
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<SignUpScreen> {
  var _formKey = GlobalKey<FormState>();

  // ── Controllers ──────────────────────────────
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  RegisetrViewModel viewModel = getIt<RegisetrViewModel>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: connect to your auth service
      viewModel.register(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        rePassword: _confirmController.text,
        phone: _phoneController.text,
      );
      debugPrint('Name   : ${_nameController.text}');
      debugPrint('Email  : ${_emailController.text}');
      debugPrint('Phone  : ${_phoneController.text}');
      debugPrint('Address: ${_addressController.text}');
      Navigator.pushReplacementNamed(context, AppRoutes.HomeRouteName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    return BlocListener<RegisetrViewModel, AuthState>(
         bloc: viewModel,
      listener: (context ,state){
        if(state is AuthLoadingState){
          DialogeUtils.showLoading(context: context, text: "Waiting...",);
        }else if (state is AuthErrorState){
          DialogeUtils.hideLoading(context: context);
          DialogeUtils.showMassage(context: context, masseage: state.errorMsg.message,posActionName: "Ok", title: "Error",);
        }else if(state is AuthSuccessState){
          DialogeUtils.hideLoading(context: context);
          DialogeUtils.showMassage(context: context, masseage: "Sign in Successfully" ,posActionName: "Ok", title: "Success",);
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
                  'Create Account',
                  style: themeProvider.apptheme == ThemeMode.dark
                      ? AppStyles.semiBold30Bagi
                      : AppStyles.semiBold30Black,
                ),
                const SizedBox(height: 4),
                Text(
                  'Start exploring Egypt today',
                  style: themeProvider.apptheme == ThemeMode.dark
                      ? AppStyles.regular16lightBlue
                      : AppStyles.regular16balck,
                ),
                const SizedBox(height: 28),

                // ── Fields ──────────────────────────
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: 'Enter your name',
                  prefixIcon: Icons.person_outline,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _phoneController,
                  label: 'Phone',
                  hint: 'Enter your phone number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Phone is required'
                      : null,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _addressController,
                  label: 'Address',
                  hint: 'Enter your address',
                  prefixIcon: Icons.location_on_outlined,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Address is required'
                      : null,
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                AppTextField(
                  controller: _confirmController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  isPassword: true,
                  prefixIcon: Icons.lock_outline,
                  validator: (v) {
                    if (v == null || v.isEmpty)
                      return 'Please confirm password';
                    if (v != _passwordController.text)
                      return 'Passwords do not match';
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
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
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
                        'OR',
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
                  icon: GoogleIcon(),
                  label: 'Continue with Google',
                  onPressed: () {},
                ),
                const SizedBox(height: 12),
                SocialButton(
                  icon: const Icon(
                    Icons.facebook,
                    color: Color(0xFF1877F2),
                    size: 22,
                  ),
                  label: 'Continue with Facebook',
                  onPressed: () {},
                ),
                const SizedBox(height: 24),

                // ── Sign In link ─────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(
                        fontSize: 13,
                        color: themeProvider.apptheme == ThemeMode.dark
                            ? AppColors.blueColor
                            : AppColors.blackColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: navigate to sign-in
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
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
