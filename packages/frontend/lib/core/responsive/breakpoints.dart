import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Breakpoints {
  static const double xs = 480;
  static const double sm = 640;
  static const double md = 900;
  static const double lg = 1200;
  static const double xl = 1600;
}

extension ContextBreakpoints on BuildContext {
  double get width => MediaQuery.sizeOf(this).width;
  bool get isWeb => kIsWeb;
  bool get isMobile => width < Breakpoints.md && !kIsWeb;
  bool get isTablet => width >= Breakpoints.md && width < Breakpoints.lg;
  bool get isDesktop =>
      width >= Breakpoints.lg || kIsWeb && width >= Breakpoints.md;
}
