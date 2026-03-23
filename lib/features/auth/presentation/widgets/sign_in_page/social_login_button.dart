import 'package:flutter/material.dart';
import '../../../../../core/theme/app_sizes.dart';

class SocialLoginButton extends StatelessWidget {
  final String? text;
  final Widget icon;
  final VoidCallback? onPressed;
  final bool isIconOnly;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? backgroundColor;
  final Color? textColor;
  final double? elevation;
  final TextStyle? textStyle;

  const SocialLoginButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.text,
    this.isIconOnly = false,
    this.padding,
    this.margin,
    this.borderRadius,
    this.border,
    this.backgroundColor,
    this.textColor,
    this.elevation,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(AppSizes.radiusMd);

    return Container(
      margin: margin,
      child: Material(
        color: backgroundColor ?? Theme.of(context).cardColor,
        borderRadius: radius,
        elevation: elevation ?? 0,
        child: InkWell(
          onTap: onPressed,
          borderRadius: radius,
          child: Container(
            width: isIconOnly ? AppSizes.iconBtnSizeLg : null,
            height: isIconOnly ? AppSizes.iconBtnSizeLg : null,
            padding: isIconOnly
                ? null
                : padding ??
                      EdgeInsets.symmetric(
                        horizontal: AppSizes.inputPaddingH,
                        vertical: AppSizes.inputPaddingV,
                      ),
            decoration: BoxDecoration(
              border:
                  border ??
                  Border.all(
                    color: Theme.of(context).colorScheme.outline,
                    width: AppSizes.borderWidth,
                  ),
              borderRadius: radius,
            ),
            alignment: isIconOnly ? Alignment.center : null,
            child: isIconOnly
                ? SizedBox(
                    width: AppSizes.iconLg,
                    height: AppSizes.iconLg,
                    child: icon,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: AppSizes.iconLg,
                        height: AppSizes.iconLg,
                        child: icon,
                      ),
                      SizedBox(width: AppSizes.spaceXs),
                      Flexible(
                        child: Text(
                          text ?? '',
                          style:
                              textStyle ??
                              Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(color: textColor),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
