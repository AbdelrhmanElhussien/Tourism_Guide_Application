import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

class InputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final IconData? prefixIcondata;
  final FormFieldValidator<String>? validator;

  const InputField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcondata,
    this.validator,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style:  TextStyle(
        fontSize: 14,
        color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.blackColor,
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        labelStyle: TextStyle(
            color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.lightGrayColor
        ),
        hintStyle:  TextStyle(
          color: themeProvider.apptheme == ThemeMode.dark ?AppColors.blueColor:AppColors.lightGrayColor,
          fontSize: 14,
        ),
        suffixIcon: widget.suffixIcon,
        contentPadding:  EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        filled: true,
        fillColor:  themeProvider.apptheme == ThemeMode.dark ?AppColors.primaryColor:AppColors.begiColor,
        prefixIcon: widget.prefixIcondata != null
            ? Icon(
          widget.prefixIcondata,
          size: 18,
          color: themeProvider.apptheme == ThemeMode.dark
              ? AppColors.blueColor
              : AppColors.blackColor,
        )
            : null,
        border:
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color:themeProvider.apptheme == ThemeMode.dark ?AppColors.cardColor:AppColors.lightyellowColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          BorderSide(color:themeProvider.apptheme == ThemeMode.dark ?AppColors.cardColor:AppColors.lightyellowColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Colors.redAccent, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
          const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        errorStyle: const TextStyle(fontSize: 11),
      ),
    );
  }
}
