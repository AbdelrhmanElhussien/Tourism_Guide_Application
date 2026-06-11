import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_colors.dart';
import 'package:tourist_app/core/utils/app_styles.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/widgets/destination_card.dart';
import 'package:tourist_app/features/AppScreens/HomeScreens/widgets/tourism_destination.dart';

class ExploreTap extends StatefulWidget {
  const ExploreTap({super.key});

  @override
  State<ExploreTap> createState() => _ExploreTapState();
}

class _ExploreTapState extends State<ExploreTap> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _sections = const ['Places', 'Events', 'Activities'];
  final List<String> _categories = const [
    'All',
    'Historical',
    'Nature',
    'Cultural',
    'Adventure',
  ];

  int _selectedSectionIndex = 0;
  String _selectedCategory = 'All';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<TourismDestination> get _filteredDestinations {
    return tourismDestinations.where((destination) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          destination.category == _selectedCategory;
      final normalizedQuery = _query.trim().toLowerCase();
      final matchesSearch =
          normalizedQuery.isEmpty ||
          destination.title.toLowerCase().contains(normalizedQuery) ||
          destination.location.toLowerCase().contains(normalizedQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final horizontalPadding = (width * 0.055).clamp(20.0, 32.0).toDouble();
        final topPadding = (width * 0.05).clamp(18.0, 28.0).toDouble();
        final cardHeight = (width * 0.75).clamp(275.0, 340.0).toDouble();
        var themeProvider = Provider.of<Themeprovider>(context);
        return SafeArea(
          child: CustomScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  topPadding,
                  horizontalPadding,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore Egypt',
                        style: AppStyles.primary24semiBold.copyWith(
                          color: themeProvider.apptheme == ThemeMode.light
                              ? Color(0xFF6d3a5f)
                              : Color(0xFFf5e6c8),
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: (width * 0.07).clamp(24.0, 34.0)),
                      _SearchAndFilterRow(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      SizedBox(height: (width * 0.055).clamp(20.0, 26.0)),
                      Divider(
                        height: 1,
                        color: isDark
                            ? AppColors.blueColor.withValues(alpha: 0.14)
                            : AppColors.socialBorder,
                      ),
                      SizedBox(height: (width * 0.04).clamp(16.0, 22.0)),
                      _SectionTabs(
                        sections: _sections,
                        selectedIndex: _selectedSectionIndex,
                        onSelected: (index) {
                          setState(() => _selectedSectionIndex = index);
                        },
                      ),
                      SizedBox(height: (width * 0.055).clamp(20.0, 26.0)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 34,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                    ),
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return _CategoryChip(
                        label: category,
                        selected: _selectedCategory == category,
                        onTap: () {
                          setState(() => _selectedCategory = category);
                        },
                      );
                    },
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  (width * 0.065).clamp(24.0, 34.0).toDouble(),
                  horizontalPadding,
                  22,
                ),
                sliver: _filteredDestinations.isEmpty
                    ? const SliverToBoxAdapter(child: _EmptyExploreState())
                    : SliverList.separated(
                        itemCount: _filteredDestinations.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: (width * 0.035).clamp(14.0, 20.0)),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: cardHeight,
                            child: DestinationCard(
                              destination: _filteredDestinations[index],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SearchAndFilterRow extends StatelessWidget {
  const _SearchAndFilterRow({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDark
        ? AppColors.bottomNavigationColor
        : const Color(0xFFFAFAFB);
    final borderColor = isDark
        ? AppColors.blueColor.withValues(alpha: 0.18)
        : Colors.transparent;
    final iconColor = isDark ? AppColors.blueColor : AppColors.lightGrayColor;
    final textColor = isDark ? AppColors.blueColor : AppColors.lightGrayColor;

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppStyles.primary12Medium.copyWith(
              color: isDark ? AppColors.begiColor : AppColors.primaryColor,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: 'Search places...',
              hintStyle: AppStyles.lightGray14Regular.copyWith(
                color: textColor,
                fontSize: 13,
              ),
              prefixIcon: Icon(Icons.search, color: iconColor),
              filled: true,
              fillColor: fieldColor,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: borderColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox.square(
          dimension: 46,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: fieldColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark
                    ? AppColors.blueColor.withValues(alpha: 0.18)
                    : AppColors.socialBorder,
              ),
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.tune,
                color: isDark ? AppColors.begiColor : AppColors.primaryColor,
                size: 21,
              ),
              tooltip: 'Filter',
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.sections,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> sections;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.bottomNavigationColor
        : const Color(0xFFFBF6EE);
    final selectedColor = isDark
        ? AppColors.darkBlueColor
        : AppColors.whiteColor;
    final selectedBorder = isDark
        ? AppColors.primaryColor.withValues(alpha: 0.85)
        : const Color(0xFFF5EBDD);
    final labelColor = isDark ? AppColors.blueColor : AppColors.primaryColor;
    final selectedLabelColor = isDark
        ? AppColors.begiColor
        : AppColors.primaryColor;

    return Container(
      height: 44,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(sections.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onSelected(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? selectedColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: selected ? Border.all(color: selectedBorder) : null,
                ),
                child: Text(
                  sections[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.primary12Medium.copyWith(
                    color: selected ? selectedLabelColor : labelColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.bottomNavigationColor
        : const Color(0xFFFBF6EE);

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      selectedColor: AppColors.yellowColor,
      backgroundColor: backgroundColor,
      side: BorderSide.none,
      labelStyle: AppStyles.primary12Medium.copyWith(
        color: selected
            ? AppColors.whiteColor
            : isDark
            ? AppColors.begiColor
            : AppColors.primaryColor,
        fontWeight: FontWeight.w700,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );
  }
}

class _EmptyExploreState extends StatelessWidget {
  const _EmptyExploreState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Text(
          'No destinations found',
          style: AppStyles.lightGray14Regular.copyWith(
            color: isDark ? AppColors.blueColor : AppColors.lightGrayColor,
          ),
        ),
      ),
    );
  }
}
