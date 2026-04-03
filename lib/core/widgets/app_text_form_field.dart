import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../config/localization/generated/l10n.dart';

/// Defines supported field types
enum FieldType { name, password, phone, email }

/// A clean, reusable text form field with built-in validation.
/// Designed for both login and sign-up forms.
class AppTextFormField extends StatefulWidget {
  final String label;
  final FieldType fieldType;
  final TextEditingController? controller;
  final bool isRequired;

  /// Whether to apply password strength validation (true for sign-up, false for login)
  final bool validateComplexity;

  /// Whether to allow toggling password visibility (only for password fields)
  final bool enablePasswordToggle;

  /// Pass the original password controller here to automatically validate
  /// that this field matches it. Only valid when fieldType is password.
  /// When provided, the external [validator] is ignored.
  final TextEditingController? matchController;

  /// Optional external validator — runs after built-in validation passes.
  /// Ignored when [matchController] is provided.
  final String? Function(String?)? validator;

  /// Optional dial code prefix for phone fields (e.g. '+20').
  /// Only used when fieldType is phone.
  final String? dialCode;

  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function(String?)? onSaved;
  final String? initialValue;

  const AppTextFormField({
    super.key,
    required this.label,
    required this.fieldType,
    this.controller,
    this.isRequired = true,
    this.validateComplexity = false,
    this.enablePasswordToggle = true,
    this.matchController,
    this.validator,
    this.dialCode,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSaved,
    this.initialValue,
  }) : assert(
         controller == null || initialValue == null,
         'Cannot provide both a controller and an initialValue',
       ),
       assert(
         matchController == null || fieldType == FieldType.password,
         'matchController can only be used with FieldType.password',
       ),
       assert(
         dialCode == null || fieldType == FieldType.phone,
         'dialCode can only be used with FieldType.phone',
       );

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _obscureText = true;

  String? _validate(String? value) {
    final text = value?.trim() ?? '';
    final s = S.of(context);

    if (widget.isRequired && text.isEmpty) {
      switch (widget.fieldType) {
        case FieldType.name:
          return s.usernameRequired;
        case FieldType.password:
          return s.passwordRequired;
        case FieldType.phone:
          return s.phoneRequired;
        case FieldType.email:
          return s.emailRequired;
      }
    }

    if (text.isEmpty) return null;

    switch (widget.fieldType) {
      case FieldType.name:
        if (text.length < 3) return s.usernameMinLength;
        break;

      case FieldType.password:
        if (widget.validateComplexity) {
          final errors = <String>[];

          if (text.length < 6) {
            errors.add(s.passwordRequirementChars);
          }
          if (!RegExp(r'[A-Z]').hasMatch(text)) {
            errors.add(s.passwordRequirementUppercase);
          }
          if (!RegExp(r'[a-z]').hasMatch(text)) {
            errors.add(s.passwordRequirementLowercase);
          }
          if (!RegExp(r'\d').hasMatch(text)) {
            errors.add(s.passwordRequirementNumber);
          }

          if (errors.isNotEmpty) {
            return s.passwordInclude(errors.join(', '));
          }
        }

        if (widget.matchController != null &&
            text != widget.matchController!.text.trim()) {
          return s.passwordsDoNotMatch;
        }
        break;

      case FieldType.phone:
        if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(text)) {
          return s.validPhoneNumber;
        }
        break;

      case FieldType.email:
        if (!EmailValidator.validate(text)) {
          return s.validEmailAddress;
        }
        break;
    }

    return widget.validator?.call(value);
  }

  TextInputType get _keyboardType {
    if (widget.keyboardType != null) return widget.keyboardType!;
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.name:
      case FieldType.password:
        return TextInputType.text;
    }
  }

  List<String> get _autofillHints {
    switch (widget.fieldType) {
      case FieldType.email:
        return const [AutofillHints.email];
      case FieldType.password:
        return widget.validateComplexity
            ? const [AutofillHints.newPassword]
            : const [AutofillHints.password];
      case FieldType.name:
        return const [AutofillHints.username];
      case FieldType.phone:
        return const [AutofillHints.telephoneNumber];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPassword = widget.fieldType == FieldType.password;
    final isEmail = widget.fieldType == FieldType.email;
    final isPhone = widget.fieldType == FieldType.phone;

    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      keyboardType: _keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: isPassword ? _obscureText : false,
      autofillHints: _autofillHints,
      onChanged: widget.onChanged,
      onSaved: widget.onSaved != null
          ? (value) => widget.onSaved!(value?.trim())
          : null,
      initialValue: widget.initialValue,
      validator: _validate,
      autocorrect: !(isPassword || isEmail),
      enableSuggestions: !isPassword,
      decoration: InputDecoration(
        labelText: widget.label,
        // dial code prefix shown only for phone fields when dialCode is provided
        prefixText: isPhone && widget.dialCode != null
            ? '${widget.dialCode} '
            : null,
        suffixIcon: isPassword && widget.enablePasswordToggle
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => _obscureText = !_obscureText);
                },
              )
            : null,
      ),
    );
  }
}
