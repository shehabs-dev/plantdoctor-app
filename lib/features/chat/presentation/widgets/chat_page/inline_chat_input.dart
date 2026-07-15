import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InlineChatInput extends StatelessWidget {
  const InlineChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.onChanged,
    this.onSubmitted,
    this.onMic,
    this.onAttachment,
    this.onVoice,
    this.focusNode,
    this.hintText = 'Type a message...',
    this.maxLines = 5,
    this.enabled = true,
    this.textFieldEnabled = true,
    this.autofocus = false,
    this.isSending = false,
    this.hasAttachment = false,
    this.showAttachment = true,
    this.showMic = true,
    this.showVoice = true,
    this.showSend = true,
    this.outerPadding,
    this.shellBackgroundColor,
    this.primaryButtonColor,
    this.hintStyle,
    this.textStyle,
    this.textFieldDecoration,
    this.textInputAction = TextInputAction.newline,
    this.keyboardType = TextInputType.multiline,
    this.sendOnEnter = false,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onMic;
  final VoidCallback? onAttachment;
  final VoidCallback? onVoice;
  final FocusNode? focusNode;
  final String hintText;
  final int maxLines;
  final bool enabled;
  final bool textFieldEnabled;
  final bool autofocus;
  final bool isSending;
  final bool showAttachment;
  final bool showMic;
  final bool showVoice;
  final bool showSend;
  final bool hasAttachment;
  final EdgeInsetsGeometry? outerPadding;
  final Color? shellBackgroundColor;
  final Color? primaryButtonColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputDecoration? textFieldDecoration;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool sendOnEnter;

  bool get _hasText => controller.text.trim().isNotEmpty;
  bool get _canEdit => enabled && !isSending;

  void _handleSend() {
    if (!_canEdit) return;
    onSend();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, _, _) {
        return SafeArea(
          top: false,
          child: Padding(
            // ── Direction-aware outer padding ──────────────────────
            padding:
                outerPadding ??
                EdgeInsetsDirectional.fromSTEB(12.w, 8.h, 12.w, 12.h),
            child: _InlineShell(
              backgroundColor:
                  shellBackgroundColor ?? theme.colorScheme.surface,
              enabled: enabled,
              textFieldEnabled: textFieldEnabled,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (showAttachment) ...[
                    Padding(
                      padding: EdgeInsets.only(bottom: 6.h),
                      child: _InlineIconButton(
                        icon: Icons.add_rounded,
                        onTap: enabled ? onAttachment : null,
                        iconColor: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 4.w),
                  ],
                  Expanded(
                    child: _InlineTextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                      onSend: _handleSend,
                      hintText: hintText,
                      maxLines: maxLines,
                      enabled: enabled && textFieldEnabled,
                      readOnly: isSending,
                      autofocus: autofocus,
                      sendOnEnter: sendOnEnter,
                      textInputAction: textInputAction,
                      keyboardType: keyboardType,
                      hintStyle: hintStyle,
                      textStyle: textStyle,
                      textFieldDecoration: textFieldDecoration,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  if (showMic) ...[
                    Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: _InlineIconButton(
                        icon: Icons.mic_none_rounded,
                        onTap: enabled ? onMic : null,
                        iconColor: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                  if (showSend || showVoice)
                    _InlinePrimaryButton(
                      hasText: _hasText,
                      hasAttachment: hasAttachment,
                      isSending: isSending,
                      onSend: enabled ? _handleSend : null,
                      onVoice: enabled ? onVoice : null,
                      showVoice: showVoice,
                      showSend: showSend,
                      backgroundColor:
                          primaryButtonColor ?? theme.colorScheme.primary,
                      iconColor: theme.colorScheme.onPrimary,
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InlineShell extends StatelessWidget {
  const _InlineShell({
    required this.child,
    required this.backgroundColor,
    required this.enabled,
    required this.textFieldEnabled,
  });

  final Widget child;
  final Color backgroundColor;
  final bool enabled;
  final bool textFieldEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Color resolvedColor = !enabled
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
        : backgroundColor;

    return Material(
      color: resolvedColor,
      elevation: 1.5,
      shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(28.r),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        // ── start has more padding (attachment side), end has less (send side)
        // DirectionalFromSTEB flips correctly in RTL ──────────────────────────
        padding: EdgeInsetsDirectional.fromSTEB(10.w, 6.h, 6.w, 6.h),
        child: child,
      ),
    );
  }
}

class _InlineTextField extends StatelessWidget {
  const _InlineTextField({
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
    required this.onSend,
    required this.hintText,
    required this.maxLines,
    required this.enabled,
    required this.readOnly,
    required this.autofocus,
    required this.sendOnEnter,
    required this.textInputAction,
    required this.keyboardType,
    this.focusNode,
    this.hintStyle,
    this.textStyle,
    this.textFieldDecoration,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback onSend;
  final String hintText;
  final int maxLines;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final bool sendOnEnter;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final InputDecoration? textFieldDecoration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final defaultDecoration = InputDecoration(
      hintText: hintText,
      hintStyle: hintStyle ?? theme.inputDecorationTheme.hintStyle,
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      isCollapsed: true,
      // ── Direction-aware content padding ────────────────────────
      contentPadding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
        vertical: 10.h,
      ),
    );

    return Focus(
      onKeyEvent: sendOnEnter
          ? (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter &&
                  !HardwareKeyboard.instance.isShiftPressed) {
                onSend();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            }
          : null,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        enabled: enabled,
        readOnly: readOnly,
        autofocus: autofocus,
        minLines: 1,
        maxLines: maxLines,
        textInputAction: sendOnEnter ? TextInputAction.send : textInputAction,
        keyboardType: keyboardType,
        style: textStyle ?? theme.textTheme.bodyLarge,
        decoration: textFieldDecoration ?? defaultDecoration,
      ),
    );
  }
}

class _InlineIconButton extends StatelessWidget {
  const _InlineIconButton({
    required this.icon,
    required this.onTap,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      constraints: BoxConstraints.tightFor(width: 36.w, height: 36.h),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      icon: Icon(icon, color: iconColor, size: 22.r),
    );
  }
}

class _InlinePrimaryButton extends StatelessWidget {
  const _InlinePrimaryButton({
    required this.hasText,
    required this.isSending,
    required this.onSend,
    required this.onVoice,
    required this.showVoice,
    required this.hasAttachment,
    required this.showSend,
    required this.backgroundColor,
    required this.iconColor,
  });

  final bool hasText;
  final bool hasAttachment;
  final bool isSending;
  final VoidCallback? onSend;
  final VoidCallback? onVoice;
  final bool showVoice;
  final bool showSend;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? action = (hasText || hasAttachment)
        ? onSend
        : (showVoice ? onVoice : onSend);

    final IconData resolvedIcon = hasText
        ? Icons.send_rounded
        : (showVoice ? Icons.graphic_eq_rounded : Icons.send_rounded);

    final Widget iconWidget = isSending
        ? SizedBox(
            width: 18.w,
            height: 18.h,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: iconColor,
            ),
          )
        : Icon(resolvedIcon, color: iconColor, size: 20.r);

    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: isSending ? null : action,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 40.w,
          height: 40.h,
          child: Center(child: iconWidget),
        ),
      ),
    );
  }
}
