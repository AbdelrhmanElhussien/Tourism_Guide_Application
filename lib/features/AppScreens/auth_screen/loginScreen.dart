import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_routes.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/signUp.dart';
class Loginscreen extends StatefulWidget {
  static const String routName = 'Loginscreen';
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  bool _obscurePassword = true;
  final _passController        = TextEditingController(text: '01155773544');
  final _emailController       = TextEditingController(text: 'abdo@gmail.com');
  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    _passController.dispose();
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // 1. Background image
              SizedBox(
                height: size.height,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/auth.jpg',
                  fit: BoxFit.cover,
                ),
              ),
          
              // 2. Gradient overlay
              Container(
                height: size.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.3, 0.95],
                  ),
                ),
              ),
          
              // 3. Liquid glass login card
              Positioned(
                bottom: size.height*0.18,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                     Text(
                      'Sign in to continue'.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
          
                    // Glass card
                    ClipRRect(
                      borderRadius: BorderRadius.circular(27),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 0.5),
                        child: Container(
                          padding:  EdgeInsets.symmetric(vertical: size.height*0.03 , horizontal: size.width*0.02),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1.5,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Email
                                GlassField(
                                  hint: 'Email'.tr(),
                                  icon: Icons.email_outlined,
                                  controller: _emailController,
                                  validation:  (v) {
                                    if (v == null || v.trim().isEmpty) return 'Email is required';
                                    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                    if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                                    return null;
                                  },
                                ),
                                 SizedBox(height: size.height*0.015),
                                // Password
                                GlassField(
                                  hint: 'Password'.tr(),
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  obscure: _obscurePassword,
                                  onToggle: () => setState(
                                        () => _obscurePassword = !_obscurePassword,
                                  ),
                                  controller:_passController ,
                                  validation: (v) {
                                    if (v == null || v.isEmpty) return 'Password is required';
                                    if (v.length < 8) return 'Minimum 8 characters';
                                    return null;
                                  },
                                ),
                                SizedBox(height: size.height*0.001),
          
                                // Forgot password
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child:  Text(
                                      'Forgot Password?'.tr(),
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.white,
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height*0.001),
                                // Sign In button
                                SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10, sigmaY: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // TODO: handle sign up
                                          if (_formKey.currentState!.validate()) {
                                            print('Sign up successful');
                                            // TODO: call your API / auth logic here
                                            Navigator.pushReplacementNamed(context, AppRoutes.HomeRouteName);
                                          }
                                          print('sign in succeffuly');
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          Colors.white.withOpacity(0.25),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(16),
                                            side: BorderSide(
                                              color:
                                              Colors.white.withOpacity(0.4),
                                            ),
                                          ),
                                        ),
                                        child:  Text(
                                          'Sign In'.tr(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
          
                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        'Or continue with'.tr(),
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.3),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
          
                                // Google & Apple
                                Row(
                                  children: [
                                    Expanded(
                                      child: _SocialButton(
                                        label: 'Google',
                                        icon: Icons.g_mobiledata_rounded,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _SocialButton(
                                        label: 'Apple',
                                        icon: Icons.apple,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
          
                                // Sign up
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Don't have an account? ".tr(),
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 13,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        print('sign up');
                                        Navigator.pushReplacementNamed(context, SignUpScreen.routName);
                                      },
                                      child:Text(
                                        'Sign Up'.tr(),
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white,
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Glass text field ──
class GlassField extends StatelessWidget {
  String hint;
  IconData icon;
  bool isPassword;
  bool obscure;
  VoidCallback? onToggle;
  TextEditingController? controller;
  TextInputType? keyboardType;
  validator? validation;
  OnChanged? onChanged;


  GlassField({
    required this.hint,
    required this.icon,
    this.validation,
    this.isPassword = false,
    this.obscure = false,
    this.onToggle,
    this.controller,
    this.keyboardType,

  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validation,
          obscureText: isPassword ? obscure : false,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.45)),
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(0.7),
                size: 20,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscure ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.7),
                  size: 20,
                ),
                onPressed: onToggle,
              )
                  : null,
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.6),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                    color: Colors.red.withOpacity(0.6),
                    width: 1,
                    style: BorderStyle.solid
                ),
              ),
              errorStyle: TextStyle(color: Colors.red , fontSize: 10 ,fontWeight: FontWeight.w900 )
          ),
        ),
      ),
    );
  }
}

// ── Social button ──
class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onToggle;


  const _SocialButton({required this.label, required this.icon , this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: OutlinedButton.icon(
          onPressed:onToggle,
          icon: Icon(icon, color: Colors.white, size: 20),
          label: Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.1),
            side: BorderSide(color: Colors.white.withOpacity(0.25)),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}