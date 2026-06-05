import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';

class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
       color: themeProvider.apptheme == ThemeMode.dark ?AppColors.begiColor:AppColors.lightGrayColor,
      ),
    );
  }
}
