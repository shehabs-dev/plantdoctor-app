import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

/// Defines supported field types
enum FieldType { username, password, phone, email }

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

  /// Core validation logic
  String? _validate(String? value) {
    final text = value?.trim() ?? '';

    if (widget.isRequired && text.isEmpty) {
      return '${widget.label} is required';
    }

    if (text.isEmpty) return null;

    switch (widget.fieldType) {
      case FieldType.username:
        if (text.length < 3) return 'Username must be at least 3 characters';
        break;

      case FieldType.password:
        // Password complexity check
        if (widget.validateComplexity) {
          final errors = <String>[];
          if (text.length < 6) errors.add('6+ chars');
          if (!RegExp(r'[A-Z]').hasMatch(text)) errors.add('uppercase');
          if (!RegExp(r'[a-z]').hasMatch(text)) errors.add('lowercase');
          if (!RegExp(r'\d').hasMatch(text)) errors.add('number');

          if (errors.isNotEmpty) return 'Include: ${errors.join(', ')}';
        }

        // Match controller check (password confirmation)
        if (widget.matchController != null &&
            text != widget.matchController!.text.trim()) {
          return 'Passwords do not match';
        }
        break;

      case FieldType.phone:
        if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(text)) {
          return 'Enter a valid phone number';
        }
        break;

      case FieldType.email:
        if (!EmailValidator.validate(text)) {
          return 'Enter a valid email address';
        }
        break;
    }

    // Run external validator only if matchController is not provided
    return widget.validator?.call(value);
  }

  TextInputType get _keyboardType {
    if (widget.keyboardType != null) return widget.keyboardType!;
    switch (widget.fieldType) {
      case FieldType.email:
        return TextInputType.emailAddress;
      case FieldType.phone:
        return TextInputType.phone;
      case FieldType.username:
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
      case FieldType.username:
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
