// lib/utils/responsive.dart
import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  Responsive(this.context);

  double get width  => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  bool get isMobile  => width < 600;
  bool get isTablet  => width >= 600 && width < 900;
  bool get isDesktop => width >= 900;

  double get cardWidth {
    if (isMobile) return double.infinity;
    if (isTablet) return 460;
    return 480;
  }

  double get screenPadding {
    if (isMobile) return 24;
    if (isTablet) return 60;
    return 80;
  }

  double sp(double size) {
    final scale = (width / 360.0).clamp(0.85, 1.3);
    return size * scale;
  }

  double get logoSize    => isMobile ? 72 : isTablet ? 80 : 88;
  double get appNameSize => isMobile ? 30 : isTablet ? 34 : 38;
  double get cardPadding => isMobile ? 24 : 32;
  double get topSpacing  => height * (isMobile ? 0.06 : isTablet ? 0.08 : 0.10);
}

extension ResponsiveExt on BuildContext {
  Responsive get r => Responsive(this);
}