import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';

class Searchewidget extends StatefulWidget {
  const Searchewidget({super.key});

  @override
  State<Searchewidget> createState() => _SearchewidgetState();
}

class _SearchewidgetState extends State<Searchewidget> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return  TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onChanged: (value) => setState(() {}),
      onSubmitted: (value) {
        // TODO: handle search submission
      },
      style: AppStyles.lightGray12Regular.copyWith(
        color: Colors.black87,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.whiteColor,
        hintText: 'search_hint'.tr(),
        hintStyle: AppStyles.lightGray12Regular,

        // Search icon on the left
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppColors.lightGrayColor,
        ),

        // Clear button — appears only when there is text
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: AppColors.lightGrayColor,
            size: 20,
          ),
          onPressed: () {
            _searchController.clear();
            setState(() {});
          },
        )
            : null,

        contentPadding: EdgeInsets.symmetric(
          vertical: size.height * 0.01,
          horizontal: size.width * 0.02,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.lightGrayColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
    ) ;
  }
}
