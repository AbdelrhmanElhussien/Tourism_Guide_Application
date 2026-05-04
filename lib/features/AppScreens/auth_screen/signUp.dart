import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/validation.dart';
import 'package:tourist_app/features/AppScreens/auth_screen/loginScreen.dart';
import 'package:tourist_app/features/widget/coustomTxtItem.dart';

class SignUpScreen extends StatefulWidget {
  static const String routName = 'SignUpScreen';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController        = TextEditingController();
  final _emailController       = TextEditingController();
  final _phoneController       = TextEditingController();
  final _addressController     = TextEditingController();
  final _passwordController    = TextEditingController();
  final _confirmController     = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
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

          // 3. Scrollable content
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: size.height * 0.04,
              ),
              child: Column(
                children: [
                   Text(
                    'Create Account'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fill in the details to get started'.tr(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.65),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Glass card
                  ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 0.5),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                          horizontal: size.width * 0.05,
                        ),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Full Name ──
                              _SectionLabel(label: 'Full Name'.tr()),
                              const SizedBox(height: 8),
                              GlassField(
                                hint: 'Please Enter Your Name'.tr(),
                                icon: Icons.person_outline,
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                                validation: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                              ),
                              SizedBox(height: size.height * 0.02),

                              // ── Email ──
                              _SectionLabel(label: 'Email'.tr()),
                              const SizedBox(height: 8),
                              GlassField(
                                hint: 'example@email.com',
                                icon: Icons.email_outlined,
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                validation:  (v) {
                                  if (v == null || v.trim().isEmpty) return 'Email is required';
                                  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                  if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * 0.02),

                              // ── Phone Number ──
                              _SectionLabel(label: 'Phone Number'.tr()),
                              const SizedBox(height: 8),
                              GlassField(
                                hint: 'Enter Your phone number'.tr(),
                                icon: Icons.phone_outlined,
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validation: (v) {
                                  if (v == null || v.trim().isEmpty) return 'Phone is required';
                                  final phoneReg = RegExp(r"01[0-2,5]{1}[0-9]{8}");
                                  if (v.trim().length < 10 && phoneReg.hasMatch(v)) return 'Enter a valid phone number';
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * 0.02),

                              // ── Address ──
                              _SectionLabel(label: 'Address'.tr()),
                              const SizedBox(height: 8),
                              GlassField(
                                hint: '123 Main St, City, Country',
                                icon: Icons.location_on_outlined,
                                controller: _addressController,
                                keyboardType: TextInputType.streetAddress,
                                validation: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
                              ),
                              SizedBox(height: size.height * 0.02),

                              // ── Password ──
                              _SectionLabel(label: 'Password'.tr()),
                              const SizedBox(height: 8),
                              GlassField(
                                hint: 'Min. 8 characters',
                                icon: Icons.lock_outline,
                                controller: _passwordController,
                                isPassword: true,
                                obscure: _obscurePassword,
                                onToggle: () => setState(
                                      () => _obscurePassword = !_obscurePassword,
                                ),
                                validation: (v) {
                                  if (v == null || v.isEmpty) return 'Password is required';
                                  if (v.length < 8) return 'Minimum 8 characters';
                                  return null;
                                },
                              ),
                              SizedBox(height: size.height * 0.02),

                              // ── Confirm Password ──
                              _SectionLabel(label: 'Confirm Password'.tr()),
                              const SizedBox(height: 8),
                              GlassField(
                                hint: 'Re-enter password'.tr(),
                                icon: Icons.lock_outline,
                                controller: _confirmController,
                                isPassword: true,
                                obscure: _obscureConfirm,
                                onToggle: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm,
                                ),
                                validation: (v) {
                                  if (v == null || v.isEmpty) return 'Please confirm your password';
                                  if (v != _passwordController.text) return 'Passwords do not match';
                                  return null;
                                },
                              ),

                              SizedBox(height: size.height * 0.035),

                              // ── Sign Up button ──
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10,
                                      sigmaY: 10,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // TODO: handle sign up
                                        if (_formKey.currentState!.validate()) {
                                          print('Sign up successful');
                                          // TODO: call your API / auth logic here
                                        }
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
                                      child: const Text(
                                        'Create Account',
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

                              // ── Divider ──
                              Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      color: Colors.white.withOpacity(0.3),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      'Or sign up with'.tr(),
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

                              // ── Google & Apple ──
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

                              // ── Already have account ──
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Already have an account? '.tr(),
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Navigator.pushReplacementNamed(context, Loginscreen.routName),
                                    child:  Text(
                                      'Sign In'.tr(),
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
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Section label ──
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white.withOpacity(0.85),
        fontSize: 13,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
    );
  }
}

// ── Glass text field ──
typedef OnChanged = Function(String);
typedef validator = String? Function(String?);
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

  const _SocialButton({required this.label, required this.icon, this.onToggle});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: OutlinedButton.icon(
          onPressed: onToggle,
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