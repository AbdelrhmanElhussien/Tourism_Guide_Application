import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tourist_app/core/utils/app_assets.dart';
import 'package:tourist_app/core/utils/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _cardAnimController;
  late Animation<Offset> _cardSlideAnim;
  late Animation<double> _cardFadeAnim;

  static const Color _goldColor = Color(0xFFE8CA7B);
  static const Color _navyColor = Color(0xFF041935);
  static const Color _accentBlue = Color(0xFF2563EB);

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      backgroundImage: AppAssets.onBoardingImage1,
      title: 'Seamless Navigation',
      description:
          'Navigate Aswan like a local with our unique Local Transportation Routes system, from feluccas to traditional buses.',
      buttonText: 'NEXT',
      showIcons: true,
    ),
    _OnboardingPageData(
      backgroundImage: AppAssets.onBoardingImage2,
      title: "Discover Aswan's Heritage",
      description:
          'Explore the ancient wonders of Egypt with curated guides to Abu Simbel, Philae Temple, and more.',
      buttonText: 'Next →',
      showIcons: false,
    ),
    _OnboardingPageData(
      backgroundImage: AppAssets.onBoardingImage3,
      title: 'Stay Informed',
      description:
          'Get Real-Time News, weather updates and local event notifications directly to your phone.',
      buttonText: 'Get Started',
      showIcons: false,
      showWeatherCard: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _cardSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOutCubic),
    );

    _cardFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimController, curve: Curves.easeOut),
    );

    _cardAnimController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cardAnimController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.loginRouteName);
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
    _cardAnimController.reset();
    _cardAnimController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),

          // Top bar — X / Skip
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // X button
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),

                  // Skip
                  GestureDetector(
                    onTap: _navigateToLogin,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingPageData data) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            data.backgroundImage,
            fit: BoxFit.cover,
          ),
        ),

        // Dark gradient overlay
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.25),
                  Colors.black.withOpacity(0.15),
                  Colors.black.withOpacity(0.55),
                  Colors.black.withOpacity(0.88),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          ),
        ),

        // Weather card (only on page 3)
        if (data.showWeatherCard)
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(top: 60.h, right: 16.w),
                child: FadeTransition(
                  opacity: _cardFadeAnim,
                  child: _WeatherAlertCard(),
                ),
              ),
            ),
          ),

        // Bottom content card
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: _cardSlideAnim,
            child: FadeTransition(
              opacity: _cardFadeAnim,
              child: _buildBottomCard(data),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomCard(_OnboardingPageData data) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 36.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          RichText(
            text: TextSpan(
              children: _buildTitleSpans(data.title),
            ),
          ),

          SizedBox(height: 10.h),

          // Description
          Text(
            data.description,
            style: GoogleFonts.inter(
              color: Colors.black87,
              fontSize: 13.sp,
              height: 1.55,
              fontWeight: FontWeight.w400,
            ),
          ),

          // Transport icons (page 1 only)
          if (data.showIcons) ...[
            SizedBox(height: 18.h),
            _buildTransportIcons(),
          ],

          SizedBox(height: 22.h),

          // Dots + Button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDots(),
              _buildNextButton(data.buttonText),
            ],
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTitleSpans(String title) {
    // Highlight key words in gold / blue
    final Map<String, Color> highlights = {
      'Seamless': const Color(0xFF1E3A5F),
      'Navigation': const Color(0xFF1E3A5F),
      "Discover": const Color(0xFF1E3A5F),
      "Aswan's": _accentBlue,
      'Heritage': _accentBlue,
      'Stay': const Color(0xFF1E3A5F),
      'Informed': const Color(0xFF1E3A5F),
    };

    final words = title.split(' ');
    return words.map((word) {
      final Color color = highlights[word] ?? const Color(0xFF1E3A5F);
      return TextSpan(
        text: '$word ',
        style: GoogleFonts.playfairDisplay(
          color: color,
          fontSize: 26.sp,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      );
    }).toList();
  }

  Widget _buildTransportIcons() {
    final icons = [
      (Icons.directions_bus_rounded, 'Bus'),
      (Icons.map_outlined, 'Map'),
      (Icons.directions_walk_rounded, 'Walking'),
    ];
    return Row(
      children: icons
          .map(
            (e) => Padding(
              padding: EdgeInsets.only(right: 18.w),
              child: Column(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: _navyColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(e.$1, color: _navyColor, size: 22.sp),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    e.$2,
                    style: GoogleFonts.inter(
                      fontSize: 10.sp,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildDots() {
    return Row(
      children: List.generate(
        _pages.length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.only(right: 6.w),
          width: index == _currentPage ? 22.w : 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: index == _currentPage
                ? _accentBlue
                : Colors.black.withOpacity(0.18),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(String label) {
    return GestureDetector(
      onTap: _goToNextPage,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 13.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
          ),
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: _accentBlue.withOpacity(0.4),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}

// ─── Weather Alert Card (page 3) ─────────────────────────────────────────────
class _WeatherAlertCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_rounded,
                  color: const Color(0xFFD97706), size: 16.sp),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  'Ptolemaic Weather',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF92400E),
                  ),
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  'Live',
                  style: GoogleFonts.inter(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFFD97706),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            'Light breeze and clear Merrit skies ahead, '
            'ideal for outdoor sightseeing. '
            'Ptolemaic for sightseeing.',
            style: GoogleFonts.inter(
              fontSize: 10.sp,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data Model ──────────────────────────────────────────────────────────────
class _OnboardingPageData {
  final String backgroundImage;
  final String title;
  final String description;
  final String buttonText;
  final bool showIcons;
  final bool showWeatherCard;

  const _OnboardingPageData({
    required this.backgroundImage,
    required this.title,
    required this.description,
    required this.buttonText,
    this.showIcons = false,
    this.showWeatherCard = false,
  });
}
