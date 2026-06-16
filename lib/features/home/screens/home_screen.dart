import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/features/home/tabs/home_tab.dart';
import 'package:tourist_app/features/explore/tabs/explore_tab.dart';
import 'package:tourist_app/features/map/tabs/map_tab.dart';
import 'package:tourist_app/features/guide/tabs/guide_tab.dart';
import 'package:tourist_app/features/profile/tabs/profile_tab.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int selectedIndex = 0;
  int selectedExploreSegment = 0; // 0: Transport, 1: Hotels, 2: Programs

  void _handleCategorySelection(String category) {
    if (category == 'transport') {
      setState(() {
        selectedIndex = 1;
        selectedExploreSegment = 0;
      });
    } else if (category == 'hotels') {
      setState(() {
        selectedIndex = 1;
        selectedExploreSegment = 1;
      });
    } else if (category == 'programs' || category == 'explore_events') {
      setState(() {
        selectedIndex = 1;
        selectedExploreSegment = 2;
      });
    } else if (category == 'guide') {
      setState(() {
        selectedIndex = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabsList = [
      HomeTab(onCategorySelected: _handleCategorySelection),
      ExploreTab(initialSegment: selectedExploreSegment),
      const MapTap(),
      const GuideTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: tabsList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          builtBottomNavBarItem(
            index: 0,
            unSelectedIcon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'home'.tr(),
          ),
          builtBottomNavBarItem(
            index: 1,
            unSelectedIcon: const Icon(Icons.search_rounded),
            selectedIcon: const Icon(Icons.search_rounded),
            label: 'explore'.tr(),
          ),
          builtBottomNavBarItem(
            index: 2,
            selectedIcon: const Icon(Icons.location_on),
            unSelectedIcon: const Icon(Icons.location_on_outlined),
            label: 'map'.tr(),
          ),
          builtBottomNavBarItem(
            index: 3,
            selectedIcon: const Icon(Icons.people_outline_rounded),
            unSelectedIcon: const Icon(Icons.people_outline_rounded),
            label: 'guide'.tr(),
          ),
          builtBottomNavBarItem(
            index: 4,
            selectedIcon: const Icon(Icons.person_2_outlined),
            unSelectedIcon: const Icon(Icons.person_2_outlined),
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
