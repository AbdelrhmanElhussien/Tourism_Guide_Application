import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/exploreTap/exploreTap.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/homeTap/homeTap.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/mapTap/mapTap.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/profileTap/profileTap.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/savedTap/savedTap.dart';

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedIndex = 0;
  List<Widget>tabsList = [hometap(),exploreTap(),mapTap(),savedTap(),profileTap()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabsList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          selectedIndex = index;
          setState(() {});
        },
        items: [
          builtBottomNavBarItem(
            index: 0,
            unSelectedIcon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'home'.tr(),
          ),
          builtBottomNavBarItem(
            index: 1,
            unSelectedIcon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'explore'.tr(),
          ),
          builtBottomNavBarItem(
            index: 2,
            selectedIcon: Icon(Icons.location_on),
            unSelectedIcon: Icon(Icons.location_on_outlined),
            label: 'map'.tr(),
          ),
          builtBottomNavBarItem(
            index: 3,
            selectedIcon: Icon(Icons.favorite),
            unSelectedIcon: Icon(Icons.favorite_border_outlined),
            label: 'saved'.tr(),
          ),
          builtBottomNavBarItem(
            index: 4,
            selectedIcon: Icon(Icons.person_2_outlined),
            unSelectedIcon: Icon(Icons.person_2_outlined),
            label: 'profile'.tr(),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem builtBottomNavBarItem({
    required Widget selectedIcon,
    required String label,
    required Widget unSelectedIcon,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: selectedIndex == index ? selectedIcon : unSelectedIcon,
      label: label,
    );
  }
}
