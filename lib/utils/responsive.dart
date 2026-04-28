import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  // ── BREAKPOINTS ──────────────────────────────────────────────
  static bool get isMobile => screenWidth < 600;
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 1024;

  // ── SAFE FIXED HELPERS ───────────────────────────────────────
  // On mobile: always return the raw value unchanged.
  // On tablet/desktop: add a small fixed increment — never multiply.

  static double font(double size) {
    if (isDesktop) return size + 2;
    if (isTablet) return size + 1;
    return size;
  }

  static double sp(double size) {
    if (isDesktop) return size + 4;
    if (isTablet) return size + 2;
    return size;
  }

  static double icon(double size) {
    if (isDesktop) return size + 3;
    if (isTablet) return size + 1;
    return size;
  }

  static double radius(double r) {
    if (isDesktop) return r + 3;
    if (isTablet) return r + 1;
    return r;
  }

  static double w(double percent) => screenWidth * percent / 100;
  static double h(double percent) => screenHeight * percent / 100;

  static double pageHPad() {
    if (isDesktop) return 32;
    if (isTablet) return 24;
    return 20;
  }

  static EdgeInsets pagePadding() {
    if (isDesktop) return const EdgeInsets.symmetric(horizontal: 32, vertical: 24);
    if (isTablet) return const EdgeInsets.symmetric(horizontal: 24, vertical: 20);
    return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  }

  static int gridCrossAxisCount({
    int mobile = 2,
    int tablet = 3,
    int desktop = 4,
  }) {
    if (isDesktop) return desktop;
    if (isTablet) return tablet;
    return mobile;
  }

  // On mobile return double.infinity — never constrain mobile width.
  static double get maxContentWidth {
    if (isDesktop) return 960;
    if (isTablet) return 720;
    return double.infinity;
  }
}

// ── HELPER WIDGETS ────────────────────────────────────────────────────────────

class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const ResponsiveContainer({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    Widget content = padding != null
        ? Padding(padding: padding!, child: child)
        : child;
    if (!Responsive.isMobile) {
      content = Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: content,
        ),
      );
    }
    return content;
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, bool, bool, bool) builder;
  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);
    return builder(
        context, Responsive.isMobile, Responsive.isTablet, Responsive.isDesktop);
  }
}