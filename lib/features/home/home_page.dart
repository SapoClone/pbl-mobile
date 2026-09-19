import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../common/resources/app_theme.dart';
import '../../core/di/di.dart';
import '../../navigation/route_const.dart';
import '../authentication/data/repository/authentication_repository.dart';
import 'home_cubit.dart';
import 'home_state.dart';

const _blue = Color(0xFF0B6EF3);
const _blueLight = Color(0xFFEAF3FF);
const _background = Color(0xFFF6F8FC);
const _textPrimary = Color(0xFF13213A);
const _textSecondary = Color(0xFF7E8AA0);
const _border = Color(0xFFE2E8F0);
const _green = Color(0xFF20B875);
const _red = Color(0xFFFF5A5F);
const _fontFamily = AppTheme.fontFamily;
const _tabularFigures = <FontFeature>[FontFeature.tabularFigures()];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HomeCubit(authenticationRepository: getIt<AuthenticationRepository>())
            ..loadDashboard(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _DashboardHeader(
                  branchName: state.branchName,
                  onLogout: () async {
                    await context.read<HomeCubit>().logout();
                    if (context.mounted) {
                      context.goNamed(AppRouteName.signIn);
                    }
                  },
                ),
                Expanded(
                  child:
                      state.status == HomeStatus.loading &&
                          state.weeklyRevenue.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(color: _blue),
                        )
                      : RefreshIndicator(
                          color: _blue,
                          onRefresh: context.read<HomeCubit>().loadDashboard,
                          child: _DashboardContent(state: state),
                        ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _HomeNavigationBar(
            selectedIndex: state.selectedNavigationIndex,
            onSelected: (index) {
              if (index == 1) {
                context.goNamed(AppRouteName.orderManagement);
                return;
              }
              context.read<HomeCubit>().navigationChanged(index);
              if (index != 0) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('This feature is under development.'),
                      duration: Duration(seconds: 1),
                    ),
                  );
              }
            },
          ),
        );
      },
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.branchName, required this.onLogout});

  final String branchName;
  final Future<void> Function() onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: _border)),
      ),
      child: Row(
        children: [
          PopupMenuButton<String>(
            tooltip: 'Account',
            onSelected: (value) {
              if (value == 'logout') onLogout();
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Text(
                  '$branchName branch',
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textSecondary,
                  ),
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: _red, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Sign out',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        color: _red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: _blueLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: _blue,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  branchName,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: _textSecondary,
                  size: 20,
                ),
              ],
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                tooltip: 'Notifications',
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: _textPrimary,
                  size: 25,
                ),
              ),
              Positioned(
                right: 9,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: _red,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.state});

  final HomeState state;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = (MediaQuery.sizeOf(context).width * 0.04).clamp(
      14.0,
      22.0,
    );

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        16,
        horizontalPadding,
        24,
      ),
      children: [
        _RevenueCard(revenue: state.todayRevenue, growth: state.revenueGrowth),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _MetricCard(
                icon: Icons.shopping_bag_outlined,
                value: state.orderCount.toString(),
                label: 'Orders',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricCard(
                icon: Icons.people_outline_rounded,
                value: state.customerCount.toString(),
                label: 'Customers',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _WeeklyRevenueCard(values: state.weeklyRevenue),
        const SizedBox(height: 12),
        _BestSellingCard(products: state.bestSellingProducts),
        const SizedBox(height: 12),
        _LowStockAlert(count: state.lowStockCount),
      ],
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.revenue, required this.growth});

  final int revenue;
  final double growth;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Today's revenue",
                  style: TextStyle(
                    fontFamily: _fontFamily,
                    color: _textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${_formatCurrency(revenue)} VND',
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      color: _textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      fontFeatures: _tabularFigures,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
            decoration: BoxDecoration(
              color: _green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '+${growth.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontFamily: _fontFamily,
                color: _green,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                fontFeatures: _tabularFigures,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _blueLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: _blue, size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFeatures: _tabularFigures,
                    letterSpacing: 0,
                  ),
                ),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: _fontFamily,
                    color: _textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyRevenueCard extends StatelessWidget {
  const _WeeklyRevenueCard({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    const labels = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Revenue in the last 7 days',
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 132,
            child: CustomPaint(
              painter: _RevenueChartPainter(values),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: labels
                .map(
                  (label) => Text(
                    label,
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      color: _textSecondary,
                      fontSize: 11,
                      fontFeatures: _tabularFigures,
                      letterSpacing: 0,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _BestSellingCard extends StatelessWidget {
  const _BestSellingCard({required this.products});

  final List<BestSellingProduct> products;

  @override
  Widget build(BuildContext context) {
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best-selling products',
            style: TextStyle(
              fontFamily: _fontFamily,
              color: _textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          ...products.indexed.map(
            (entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: entry.$1 == 0 ? _blueLight : _background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${entry.$1 + 1}',
                      style: TextStyle(
                        fontFamily: _fontFamily,
                        color: entry.$1 == 0 ? _blue : _textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFeatures: _tabularFigures,
                        letterSpacing: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.$2.name,
                      style: const TextStyle(
                        fontFamily: _fontFamily,
                        color: _textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    '${entry.$2.quantity}',
                    style: const TextStyle(
                      fontFamily: _fontFamily,
                      color: _textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFeatures: _tabularFigures,
                      letterSpacing: 0,
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
}

class _LowStockAlert extends StatelessWidget {
  const _LowStockAlert({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _red, size: 23),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count products are low in stock',
              style: const TextStyle(
                fontFamily: _fontFamily,
                color: _red,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFeatures: _tabularFigures,
                letterSpacing: 0,
              ),
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: _red),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A17233C),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _HomeNavigationBar extends StatelessWidget {
  const _HomeNavigationBar({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        height: 70,
        backgroundColor: Colors.white,
        indicatorColor: _blueLight,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontFamily: _fontFamily,
            color: states.contains(WidgetState.selected)
                ? _blue
                : _textSecondary,
            fontSize: 11,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? _blue
                : _textSecondary,
            size: 22,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner_rounded),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Reports',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  const _RevenueChartPainter(this.values);

  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;

    final gridPaint = Paint()
      ..color = _border
      ..strokeWidth = 1;
    for (var index = 0; index < 4; index++) {
      final y = size.height * index / 3;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final range = math.max(maxValue - minValue, 1);
    final points = <Offset>[];
    for (var index = 0; index < values.length; index++) {
      final x = size.width * index / (values.length - 1);
      final normalized = (values[index] - minValue) / range;
      final y = size.height - (normalized * (size.height - 14)) - 7;
      points.add(Offset(x, y));
    }

    final areaPath = Path()
      ..moveTo(points.first.dx, size.height)
      ..lineTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      areaPath.lineTo(point.dx, point.dy);
    }
    areaPath
      ..lineTo(points.last.dx, size.height)
      ..close();
    canvas.drawPath(
      areaPath,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0x33176FF2), Color(0x00176FF2)],
        ).createShader(Offset.zero & size),
    );

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      linePath.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      linePath,
      Paint()
        ..color = _blue
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final pointPaint = Paint()..color = _blue;
    for (final point in points) {
      canvas
        ..drawCircle(point, 3, pointPaint)
        ..drawCircle(point, 1.4, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueChartPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

String _formatCurrency(int value) {
  return NumberFormat.decimalPattern('en_US').format(value);
}
