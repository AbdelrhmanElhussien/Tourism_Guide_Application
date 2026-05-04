import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';

class RecommendedWidget extends StatelessWidget {
  const RecommendedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      width: size.width*0.6,
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow:  [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(2, 5),
            ),
          ],
          border: Border.all(
            color: AppColors.blackColor.withOpacity(0.05),
            width: 1.5
          )
      ),
      child: Column(
        spacing: 2.5,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
              child: Image.asset(AppAssets.pyramidsofGiza)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('pyramids of Giza' , style: AppStyles.primary18Medium,),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined , color: AppColors.lightGrayColor,),
                    Text('Giza,Egypt'),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.yellowColor,),
                    Text('4.9(1253)'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
