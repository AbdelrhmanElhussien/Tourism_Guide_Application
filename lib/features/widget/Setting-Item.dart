// import 'package:evently_app/provider/app_theme_provider.dart';
// import 'package:evently_app/util/appColor.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class settingItem extends StatelessWidget {
//   String text;
//   Widget item;
//   settingItem({super.key , required this.text , required this.item});
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     var themeProvider = Provider.of<appThemeProvider>(context);
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: size.width*0.01 , vertical: size.height*0.01),
//       decoration: BoxDecoration(
//         color:Theme.of(context).cardColor ,
//         borderRadius:BorderRadius.circular(16),
//         border: Border.all(
//           color:themeProvider.appTheme == ThemeMode.dark
//               ?appcolorDrakeMode.StrokeColorDarkMode
//               :appcolorLightMode.StrokeColorLightMode,
//           width: 1
//         )
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(text, style: Theme.of(context).textTheme.headlineMedium,),
//           item
//         ],
//       ),
//     );
//   }
// }
