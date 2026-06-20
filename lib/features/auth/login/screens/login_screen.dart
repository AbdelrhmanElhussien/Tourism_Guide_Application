import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_loclization.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/core/utils/dialoge_utils.dart';
import 'package:tourist_app/features/auth/login/cubit/login_view_model.dart';
import 'package:tourist_app/features/auth/cubit/auth_states.dart';
import 'package:tourist_app/features/auth/widgets/google_icon.dart';
import 'package:tourist_app/features/auth/widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController(text: 'provider2@example.com');
  final _passwordController = TextEditingController(text: 'Provider@123456');
  final _formKey = GlobalKey<FormState>();
  final Loginviewmodel viewModel = getIt<Loginviewmodel>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _buildLanguageSelector({required bool isDark}) {
    final Map<String, String> languages = {
      'en': 'English',
      'ar': 'العربية',
      'de': 'Deutsch',
      'fr': 'Français',
      'it': 'Italiano',
      'es': 'Español',
      'ru': 'Русский',
      'zh': '中文',
    };

    final currentLangCode = context.locale.languageCode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LANGUAGE',
          style: TextStyle(
            color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Theme(
          data: Theme.of(context).copyWith(
            cardColor: isDark ? AppColors.bottomNavigationColor : Colors.white,
          ),
          child: PopupMenuButton<String>(
            color: isDark ? AppColors.bottomNavigationColor : Colors.white,
            initialValue: currentLangCode,
            onSelected: (String code) {
              context.setLocale(Locale(code));
            },
            itemBuilder: (BuildContext context) {
              return languages.entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: currentLangCode == entry.key
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList();
            },
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101E2E)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.language,
                    size: 14,
                    color: isDark ? Colors.white : AppColors.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    currentLangCode.toUpperCase(),
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: isDark ? Colors.white : AppColors.primaryColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedToggle({
    required String label,
    required List<String> options,
    required List<IconData> icons,
    required int selectedIndex,
    required Function(int) onToggle,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 38,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF101E2E) : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(options.length, (idx) {
              final selected = selectedIndex == idx;
              return GestureDetector(
                onTap: () => onToggle(idx),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? (isDark ? const Color(0xFF1E2F46) : Colors.white)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[idx],
                        size: 14,
                        color: selected
                            ? (isDark ? Colors.white : AppColors.primaryColor)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        options[idx],
                        style: TextStyle(
                          color: selected
                              ? (isDark ? Colors.white : AppColors.primaryColor)
                              : Colors.grey,
                          fontSize: 12,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required bool isDark,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(
            color: isDark ? Colors.white : AppColors.primaryColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.withOpacity(0.6),
              fontSize: 14,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark ? const Color(0xFF101E2E) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF1E3A5F)
                    : const Color(0xFFE2E8F0),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.yellowColor,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isDark = themeProvider.apptheme == ThemeMode.dark;
    var size = MediaQuery.of(context).size;

    return BlocListener<Loginviewmodel, AuthState>(
      bloc: viewModel,
      listener: (context, state) {
        if (state is AuthLoadingState) {
          DialogeUtils.showLoading(context: context, text: "loading_msg".tr());
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
            masseage: "login_success_msg".tr(),
            posActionName: "ok_action".tr(),
            title: "success_title".tr(),
            posFun: () {
              Navigator.pushReplacementNamed(context, AppRoutes.HomeRouteName);
            },
          );
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBlueColor
            : const Color(0xffF8FAFC),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Appearance & Language Switchers Row ────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSegmentedToggle(
                        label: 'APPEARANCE',
                        options: ['Light', 'Dark'],
                        icons: [
                          Icons.wb_sunny_outlined,
                          Icons.nightlight_outlined,
                        ],
                        selectedIndex: isDark ? 1 : 0,
                        onToggle: (idx) {
                          if (idx == 0) {
                            themeProvider.changeTheme(ThemeMode.light);
                          } else {
                            themeProvider.changeTheme(ThemeMode.dark);
                          }
                        },
                        isDark: isDark,
                      ),
                      _buildLanguageSelector(isDark: isDark),
                    ],
                  ),
                  SizedBox(height: size.height * 0.05),

                  // ── Welcome Header ──────────────────────────────────────
                  Text(
                    'welcome_back'.tr(),
                    style: TextStyle(
                      color: isDark ? Colors.white : AppColors.primaryColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'sign_in_to_continue'.tr(),
                    style: TextStyle(
                      color: isDark
                          ? AppColors.blueColor
                          : AppColors.lightGrayColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Email Input Field ───────────────────────────────────
                  _buildTextField(
                    controller: _emailController,
                    labelText: 'email'.tr(),
                    hintText: 'Enter your email',
                    isDark: isDark,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'please_enter_email'.tr();
                      }
                      final re = RegExp(r'^[\w.+-]+@[\w-]+\.[a-zA-Z]+$');
                      if (!re.hasMatch(v))
                        return 'please_enter_valid_email'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // ── Password Input Field ────────────────────────────────
                  _buildTextField(
                    controller: _passwordController,
                    labelText: 'password'.tr(),
                    hintText: 'Enter your password',
                    isDark: isDark,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty)
                        return 'please_enter_password'.tr();
                      if (v.length < 6) return 'password_min_6'.tr();
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // ── Forgot Password Link ────────────────────────────────
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.resetPasswordRouteName,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'forgot_password'.tr(),
                        style: const TextStyle(
                          color: AppColors.yellowColor,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Sign In Button ──────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          viewModel.login(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.yellowColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'sign_in'.tr(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── OR Divider ──────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: isDark
                              ? AppColors.blueColor.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.blueColor
                                : AppColors.lightGrayColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: isDark
                              ? AppColors.blueColor.withOpacity(0.2)
                              : Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Social Login Buttons ────────────────────────────────
                  SocialButton(
                    onPressed: () {},
                    icon: const GoogleIcon(),
                    label: 'Continue with Google',
                  ),
                  const SizedBox(height: 12),

                  SocialButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.facebook,
                      color: Color(0xFF1877F2),
                      size: 22,
                    ),
                    label: 'Continue with Facebook',
                  ),
                  const SizedBox(height: 32),

                  // ── Sign Up Navigation Link ─────────────────────────────
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "dont_have_account".tr(),
                          style: TextStyle(
                            color: isDark
                                ? AppColors.blueColor
                                : AppColors.lightGrayColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.signUpRouteName,
                            );
                          },
                          child: Text(
                            'sign_up'.tr(),
                            style: const TextStyle(
                              color: AppColors.yellowColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
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
