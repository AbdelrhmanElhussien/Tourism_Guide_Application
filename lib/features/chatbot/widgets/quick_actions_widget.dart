import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';

class QuickActionData {
  final String label;
  final IconData icon;
  final Color lightBg;
  final Color darkBg;
  final Color color;

  const QuickActionData({
    required this.label,
    required this.icon,
    required this.lightBg,
    required this.darkBg,
    required this.color,
  });
}

class QuickActionsWidget extends StatelessWidget {
  final Function(String) onActionTap;
  final List<String>? filterActions;

  const QuickActionsWidget({
    super.key,
    required this.onActionTap,
    this.filterActions,
  });

  static const List<QuickActionData> _allActions = [
    QuickActionData(
      label: 'Recommend Places',
      icon: Icons.location_on_outlined,
      lightBg: Color(0xFFFBF4E6),
      darkBg: Color(0x22B8963E),
      color: Color(0xFFB8963E),
    ),
    QuickActionData(
      label: 'Find Hotels',
      icon: Icons.apartment_outlined,
      lightBg: Color(0xFFE6F7F5),
      darkBg: Color(0x223B9388),
      color: Color(0xFF2C7A7B),
    ),
    QuickActionData(
      label: 'Plan My Trip',
      icon: Icons.route_outlined,
      lightBg: Color(0xFFEBF8FF),
      darkBg: Color(0x222B6CB0),
      color: Color(0xFF2B6CB0),
    ),
    QuickActionData(
      label: 'Find Guides',
      icon: Icons.people_outline_rounded,
      lightBg: Color(0xFFFFF5F5),
      darkBg: Color(0x22C05621),
      color: Color(0xFFC05621),
    ),
    QuickActionData(
      label: 'Transportation Options',
      icon: Icons.directions_bus_filled_outlined,
      lightBg: Color(0xFFF0FFF4),
      darkBg: Color(0x222F855A),
      color: Color(0xFF2F855A),
    ),
    QuickActionData(
      label: 'Nearby Attractions',
      icon: Icons.attractions_outlined,
      lightBg: Color(0xFFFFF5F7),
      darkBg: Color(0x22B83280),
      color: Color(0xFFB83280),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<Themeprovider>(context);
    final isDark = themeProvider.apptheme == ThemeMode.dark;

    final actionsToShow = filterActions == null
        ? _allActions
        : _allActions.where((act) => filterActions!.contains(act.label)).toList();

    if (actionsToShow.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: actionsToShow.length,
        itemBuilder: (context, index) {
          final action = actionsToShow[index];
          final bgColor = isDark ? action.darkBg : action.lightBg;
          
          return Container(
            margin: const EdgeInsets.only(right: 10),
            child: Material(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onActionTap(action.label),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        action.icon,
                        size: 16,
                        color: action.color,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        action.label,
                        style: TextStyle(
                          color: action.color,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
