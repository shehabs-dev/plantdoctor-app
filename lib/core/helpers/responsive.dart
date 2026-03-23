enum ScreenType { mobile, tablet, desktop }

class Responsive {
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;

  static ScreenType getScreenType(double width) {
    if (width >= tabletMaxWidth) return ScreenType.desktop;
    if (width >= mobileMaxWidth) return ScreenType.tablet;
    return ScreenType.mobile;
  }

  static T value<T>({
    required double width,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    switch (getScreenType(width)) {
      case ScreenType.desktop:
        return desktop ?? tablet ?? mobile;
      case ScreenType.tablet:
        return tablet ?? mobile;
      case ScreenType.mobile:
        return mobile;
    }
  }
}