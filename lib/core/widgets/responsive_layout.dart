import 'package:flutter/widgets.dart';
import '../helpers/responsive.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Responsive.value(
          width: constraints.maxWidth, //  Use constraints, not MediaQuery
          mobile: mobile,
          tablet: tablet,
          desktop: desktop,
        );
      },
    );
  }
}
