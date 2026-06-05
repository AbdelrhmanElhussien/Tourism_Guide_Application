import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/app_styles.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/FieldLabel.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/GoogleIcon.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/InputField.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/widgets/SocialButton.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

@override
class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: size.height * 0.05),
                // ── Header ──────────────────────────────
                Text(
                  'Welcome Back',
                  style: themeProvider.apptheme == ThemeMode.dark
                      ? AppStyles.semiBold30Bagi
                      : AppStyles.semiBold30Black,
                ),
                const SizedBox(height: 6),
                Text(
                  'Sign in to continue your journey',
                  style:themeProvider.apptheme == ThemeMode.dark ?AppStyles.regular16lightBlue:AppStyles.regular16balck,

                ),
                const SizedBox(height: 36),

                // ── Email ────────────────────────────────
                FieldLabel(text: 'Email'),
                SizedBox(height: size.height * 0.009),
                InputField(
                  controller: _emailController,
                  hint: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcondata: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty)
                      return 'Email is required';
                    final re = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]+$');
                    if (!re.hasMatch(v)) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // ── Password ─────────────────────────────
                FieldLabel(text: 'Password'),

                InputField(
                  controller: _passwordController,
                  hint: 'Enter your password',
                  obscureText: _obscurePassword,
                  prefixIcondata: Icons.lock_outline,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.hint,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // ── Forgot password ──────────────────────
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: AppColors.gold,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── Sign In button ───────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // TODO: auth logic
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── OR divider ───────────────────────────
                Row(
                  children: [
                    Expanded(child: Divider(color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.blackColor,)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 12,
                          color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.blackColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.blackColor,)),
                  ],
                ),
                const SizedBox(height: 20),

                // ── Google ───────────────────────────────
                SocialButton(
                  onPressed: () {},
                  icon: GoogleIcon(),
                  label: 'Continue with Google',
                ),
                const SizedBox(height: 12),

                // ── Facebook ─────────────────────────────
                SocialButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.facebook,
                    color: Color(0xFF1877F2),
                    size: 22,
                  ),
                  label: 'Continue with Facebook',
                ),
                const SizedBox(height: 36),

                // ── Sign up link ─────────────────────────
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account?  ",
                      style:  TextStyle(
                        color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.blackColor,
                        fontSize: 13,
                      ),
                      children: [
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.signUpRouteName,
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,

                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
