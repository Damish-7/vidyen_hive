import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double _blockSizeH;
  static late double _blockSizeV;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    _blockSizeH = screenWidth / 100;
    _blockSizeV = screenHeight / 100;
  }

  // ── BREAKPOINTS ──────────────────────────────────────────────
  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 1024;

  // ── FLUID SIZING ─────────────────────────────────────────────
  /// Percentage of screen width
  static double w(double percent) => _blockSizeH * percent;

  /// Percentage of screen height
  static double h(double percent) => _blockSizeV * percent;

  /// Responsive font size — scales between min and max
  static double font(double size) {
    if (isDesktop) return size * 1.2;
    if (isTablet) return size * 1.1;
    return size;
  }

  /// Responsive spacing
  static double sp(double size) {
    if (isDesktop) return size * 1.3;
    if (isTablet) return size * 1.15;
    return size;
  }

  /// Responsive padding — returns EdgeInsets symmetric horizontal
  static EdgeInsets pagePadding() {
    if (isDesktop) return EdgeInsets.symmetric(horizontal: w(20));
    if (isTablet) return EdgeInsets.symmetric(horizontal: w(8));
    return EdgeInsets.symmetric(horizontal: w(5.5));
  }

  /// Responsive horizontal padding value only
  static double pageHPad() {
    if (isDesktop) return w(20);
    if (isTablet) return w(8);
    return w(5.5);
  }

  /// Cross-axis count for grids
  static int gridCrossAxisCount({int mobile = 2, int tablet = 3, int desktop = 4}) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }

  /// Responsive icon size
  static double icon(double size) {
    if (isTablet) return size * 1.15;
    if (isDesktop) return size * 1.25;
    return size;
  }

  /// Card border radius
  static double radius(double r) {
    if (isTablet || isDesktop) return r * 1.2;
    return r;
  }

  /// Max content width for desktop layouts
  static double get maxContentWidth {
    if (isDesktop) return 900;
    if (isTablet) return 700;
    return screenWidth;
  }
}

/// Wrap this around any screen body to constrain width on tablet/desktop
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const ResponsiveContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth),
        child: padding != null ? Padding(padding: padding!, child: child) : child,
      ),
    );
  }
}

/// Use in build() to init Responsive then return child
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, bool isMobile, bool isTablet, bool isDesktop) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return builder(context, Responsive.isMobile, Responsive.isTablet, Responsive.isDesktop);
  }
}