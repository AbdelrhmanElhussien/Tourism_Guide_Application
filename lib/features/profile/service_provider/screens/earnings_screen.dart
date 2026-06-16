import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tourist_app/core/di/di.dart';
import 'package:tourist_app/core/provider/themeProvider.dart';
import 'package:tourist_app/core/utils/app_theme.dart';
import 'package:tourist_app/domain/entities/provider/provider_earnings.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_dashboard_cubit.dart';
import 'package:tourist_app/features/profile/service_provider/cubits/provider_dashboard_states.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<Themeprovider>(context);
    bool isLight = themeProvider.apptheme == ThemeMode.light;
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => getIt<ProviderDashboardCubit>()..fetchDashboardData(),
      child: Scaffold(
        backgroundColor: isLight ? const Color(0xffF8FAFC) : AppColors.darkBlueColor,
        body: SafeArea(
          top: false,
          bottom: true,
          child: Column(
            children: [
              // Header Section
              _buildHeader(context, size),

              // Content
              Expanded(
                child: BlocBuilder<ProviderDashboardCubit, ProviderDashboardState>(
                  builder: (context, state) {
                    if (state is ProviderDashboardLoading || state is ProviderDashboardInitial) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColors.primaryColor),
                      );
                    } else if (state is ProviderDashboardError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.errorMsg,
                              style: TextStyle(color: isLight ? Colors.black : Colors.white),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProviderDashboardCubit>().fetchDashboardData();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is ProviderDashboardSuccess) {
                      final earnings = state.earnings;
                      return RefreshIndicator(
                        onRefresh: () => context.read<ProviderDashboardCubit>().fetchDashboardData(),
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Stats Banner
                              _buildStatsCard(isLight, earnings),
                              const SizedBox(height: 20),

                              // Monthly Overview with animated graph
                              _buildOverviewCard(isLight, earnings.monthlyOverview),
                              const SizedBox(height: 20),

                              // Recent Transactions
                              _buildTransactionsCard(isLight, earnings.recentTransactions),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Size size) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, size.height * 0.06, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // Back button
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Text(
            "view_earnings".tr(),
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(bool isLight, ProviderEarnings earnings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF162535),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight ? Colors.black.withOpacity(0.05) : AppColors.blueColor.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "total_earnings".tr(),
                style: GoogleFonts.inter(
                  color: isLight ? const Color(0xFF64748B) : AppColors.blueColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${earnings.totalEarnings.toInt()} EGP",
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.primaryColor : Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.trending_up,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    earnings.earningsGrowth,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.yellowColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.account_balance_wallet_outlined,
              color: AppColors.yellowColor,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(bool isLight, List<double> monthlyOverview) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF162535),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight ? Colors.black.withOpacity(0.05) : AppColors.blueColor.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "monthly_overview".tr() == "monthly_overview" ? "Monthly Overview" : "monthly_overview".tr(),
                style: GoogleFonts.inter(
                  color: isLight ? AppColors.primaryColor : AppColors.yellowColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'downloading_report'.tr() == 'downloading_report' 
                            ? 'Downloading report...' 
                            : 'downloading_report'.tr(),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isLight ? const Color(0xFFEEF2F6) : const Color(0xFF101E2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.download,
                        size: 14,
                        color: isLight ? AppColors.primaryColor : Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "export".tr() == "export" ? "Export" : "export".tr(),
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isLight ? AppColors.primaryColor : Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: TweenAnimationBuilder<double>(
              key: ValueKey(monthlyOverview),
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOutCubic,
              builder: (context, value, child) {
                return CustomPaint(
                  painter: LineChartPainter(
                    values: monthlyOverview,
                    animationValue: value,
                    isDark: !isLight,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsCard(bool isLight, List<ProviderTransaction> transactions) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF162535),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isLight ? Colors.black.withOpacity(0.05) : AppColors.blueColor.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "recent_bookings".tr(),
            style: GoogleFonts.inter(
              color: isLight ? AppColors.primaryColor : Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (transactions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  "no_transactions_found".tr() == "no_transactions_found" ? "No transactions found" : "no_transactions_found".tr(),
                  style: TextStyle(color: isLight ? Colors.grey : Colors.white70),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Divider(
                color: isLight ? Colors.grey.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                height: 20,
              ),
              itemBuilder: (context, index) {
                final item = transactions[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.inter(
                              color: isLight ? AppColors.primaryColor : Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.date,
                            style: GoogleFonts.inter(
                              color: isLight ? const Color(0xFF64748B) : AppColors.blueColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      "${item.amount > 0 ? '+' : ''}${item.amount.toInt()} EGP",
                      style: GoogleFonts.inter(
                        color: item.isCredit ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> values;
  final double animationValue;
  final bool isDark;

  LineChartPainter({required this.values, required this.animationValue, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    const double leftPadding = 35.0;
    const double rightPadding = 15.0;
    const double topPadding = 15.0;
    const double bottomPadding = 25.0;

    final double chartWidth = size.width - leftPadding - rightPadding;
    final double chartHeight = size.height - topPadding - bottomPadding;

    // Grid details
    final Paint gridPaint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04)
      ..strokeWidth = 1.0;

    // Determine max value
    final double maxVal = values.isEmpty ? 1000.0 : values.reduce((curr, next) => curr > next ? curr : next);
    final double chartMax = maxVal == 0 ? 1000.0 : (maxVal * 1.2); // 20% margin

    // Draw horizontal grid lines and labels
    for (int j = 1; j <= 3; j++) {
      final double gridVal = (chartMax / 4) * j;
      final double y = topPadding + chartHeight * (1 - gridVal / chartMax);
      canvas.drawLine(Offset(leftPadding, y), Offset(leftPadding + chartWidth, y), gridPaint);

      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: gridVal >= 1000 ? '${(gridVal / 1000).toStringAsFixed(1)}k' : gridVal.toInt().toString(),
          style: TextStyle(
            color: isDark ? Colors.white30 : Colors.black38,
            fontSize: 10,
            fontFamily: 'Roboto',
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(5, y - tp.height / 2));
    }

    if (values.isEmpty) return;

    final List<double> xPoints = [];
    final List<double> yPoints = [];

    for (int i = 0; i < values.length; i++) {
      final double x = leftPadding + (values.length <= 1 ? 0 : (i * chartWidth / (values.length - 1)));
      final double y = topPadding + chartHeight * (1 - values[i] / chartMax);
      xPoints.add(x);
      yPoints.add(y);
    }

    // Draw curve path
    final Path path = Path();
    path.moveTo(xPoints[0], yPoints[0]);
    for (int i = 0; i < xPoints.length - 1; i++) {
      final double x1 = xPoints[i];
      final double y1 = yPoints[i];
      final double x2 = xPoints[i + 1];
      final double y2 = yPoints[i + 1];

      final double cx1 = x1 + (x2 - x1) / 2.0;
      final double cy1 = y1;
      final double cx2 = x1 + (x2 - x1) / 2.0;
      final double cy2 = y2;

      path.cubicTo(cx1, cy1, cx2, cy2, x2, y2);
    }

    // Animated Path length extraction
    final List<ui.PathMetric> pathMetrics = path.computeMetrics().toList();
    if (pathMetrics.isNotEmpty) {
      final ui.PathMetric metric = pathMetrics.first;
      final double animatedLength = metric.length * animationValue;
      final Path extracted = metric.extractPath(0.0, animatedLength);

      // Gradient Fill underneath the path
      final Paint fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.yellowColor.withOpacity(0.25),
            AppColors.yellowColor.withOpacity(0.0),
          ],
        ).createShader(Rect.fromLTRB(leftPadding, topPadding, leftPadding + chartWidth, topPadding + chartHeight))
        ..style = PaintingStyle.fill;

      if (animationValue > 0) {
        final Path fillPath = Path();
        fillPath.addPath(extracted, Offset.zero);
        final ui.Tangent? tangent = metric.getTangentForOffset(animatedLength);
        if (tangent != null) {
          final Offset pos = tangent.position;
          fillPath.lineTo(pos.dx, topPadding + chartHeight);
          fillPath.lineTo(xPoints[0], topPadding + chartHeight);
          fillPath.close();
          canvas.drawPath(fillPath, fillPaint);
        }
      }

      // Curve line
      final Paint linePaint = Paint()
        ..color = AppColors.yellowColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(extracted, linePaint);

      // Dot outline & inner paints
      final Paint dotOutlinePaint = Paint()
        ..color = AppColors.yellowColor
        ..style = PaintingStyle.fill;
      final Paint dotInnerPaint = Paint()
        ..color = isDark ? const Color(0xFF162535) : Colors.white
        ..style = PaintingStyle.fill;

      // Draw indicators (dots) as animation progresses
      for (int i = 0; i < xPoints.length; i++) {
        final double pointProgress = i / (xPoints.length - 1);
        if (animationValue >= pointProgress) {
          canvas.drawCircle(Offset(xPoints[i], yPoints[i]), 5.0, dotOutlinePaint);
          canvas.drawCircle(Offset(xPoints[i], yPoints[i]), 3.0, dotInnerPaint);
        }
      }
    }

    // Bottom labels (Jan, Feb, Mar, Apr, ...)
    final List<String> defaultMonths = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    for (int i = 0; i < values.length; i++) {
      final String monthLabel = defaultMonths[i % defaultMonths.length];
      final TextPainter tp = TextPainter(
        text: TextSpan(
          text: monthLabel,
          style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black54,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(xPoints[i] - tp.width / 2, topPadding + chartHeight + 8));
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || 
        oldDelegate.isDark != isDark ||
        oldDelegate.values != values;
  }
}
