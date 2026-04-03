// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(requirements) => "Include: ${requirements}";

  static String m1(seconds) => "Resend in ${seconds} s";

  static String m2(email) =>
      "A verification link has been sent to:\n${email}\nPlease verify your account to continue.";

  static String m3(seconds) => "Wait ${seconds}s to Resend";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "appName": MessageLookupByLibrary.simpleMessage("PlantDoctor"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "AI Plant Disease Detection",
    ),
    "assistant": MessageLookupByLibrary.simpleMessage("Assistant"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createAccountDescription": MessageLookupByLibrary.simpleMessage(
      "Create your account to start detecting plant diseases instantly",
    ),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "emailAddress": MessageLookupByLibrary.simpleMessage("Email Address"),
    "emailAlreadyInUse": MessageLookupByLibrary.simpleMessage(
      "An account with this email already exists.",
    ),
    "emailNotVerified": MessageLookupByLibrary.simpleMessage(
      "Your email has not been verified yet.",
    ),
    "emailRequired": MessageLookupByLibrary.simpleMessage("Email is required"),
    "emailVerificationSent": MessageLookupByLibrary.simpleMessage(
      "A verification email has been sent. Please check your inbox.",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "forgotPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your email address and we will send you a link to reset your password.",
    ),
    "forgotYourPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot your password?",
    ),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "iVerifiedMyEmail": MessageLookupByLibrary.simpleMessage(
      "I Verified My Email",
    ),
    "invalidCredential": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password.",
    ),
    "joinPlantDoctor": MessageLookupByLibrary.simpleMessage(
      "Join PlantDoctor 🌱",
    ),
    "ministry": MessageLookupByLibrary.simpleMessage("Ministry"),
    "noChatHistoryYet": MessageLookupByLibrary.simpleMessage(
      "No chat history yet",
    ),
    "notAuthenticated": MessageLookupByLibrary.simpleMessage(
      "No account found with this email. Please sign up first.",
    ),
    "offlineError": MessageLookupByLibrary.simpleMessage(
      "You\'re offline. Please check your internet connection.",
    ),
    "or": MessageLookupByLibrary.simpleMessage("or"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "passwordInclude": m0,
    "passwordRequired": MessageLookupByLibrary.simpleMessage(
      "Password is required",
    ),
    "passwordRequirementChars": MessageLookupByLibrary.simpleMessage(
      "6+ chars",
    ),
    "passwordRequirementLowercase": MessageLookupByLibrary.simpleMessage(
      "lowercase",
    ),
    "passwordRequirementNumber": MessageLookupByLibrary.simpleMessage("number"),
    "passwordRequirementUppercase": MessageLookupByLibrary.simpleMessage(
      "uppercase",
    ),
    "passwordResetSent": MessageLookupByLibrary.simpleMessage(
      "A password reset email has been sent. Please check your inbox to reset your password.",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Passwords do not match",
    ),
    "phoneRequired": MessageLookupByLibrary.simpleMessage(
      "Phone number is required",
    ),
    "postAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Post added successfully",
    ),
    "postDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Post deleted successfully",
    ),
    "postUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "Post updated successfully",
    ),
    "report": MessageLookupByLibrary.simpleMessage("Report"),
    "resendEmail": MessageLookupByLibrary.simpleMessage("Resend Email"),
    "resendInSeconds": m1,
    "sendResetLink": MessageLookupByLibrary.simpleMessage("Send Reset Link"),
    "sending": MessageLookupByLibrary.simpleMessage("Sending..."),
    "serverError": MessageLookupByLibrary.simpleMessage(
      "We\'re having trouble connecting to the server. Please try again.",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign In"),
    "signInAborted": MessageLookupByLibrary.simpleMessage(
      "Sign in was cancelled.",
    ),
    "signInWithApple": MessageLookupByLibrary.simpleMessage(
      "Sign in with Apple",
    ),
    "signInWithFacebook": MessageLookupByLibrary.simpleMessage(
      "Sign in with Facebook",
    ),
    "signInWithGitHub": MessageLookupByLibrary.simpleMessage(
      "Sign in with GitHub",
    ),
    "signInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Sign in with Google",
    ),
    "signInWithLinkedIn": MessageLookupByLibrary.simpleMessage(
      "Sign in with LinkedIn",
    ),
    "signInWithMicrosoft": MessageLookupByLibrary.simpleMessage(
      "Sign in with Microsoft",
    ),
    "signInWithX": MessageLookupByLibrary.simpleMessage("Sign in with X"),
    "signOut": MessageLookupByLibrary.simpleMessage("Sign Out"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "tooManyRequests": MessageLookupByLibrary.simpleMessage(
      "Too many attempts. Please try again later.",
    ),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again.",
    ),
    "usernameMinLength": MessageLookupByLibrary.simpleMessage(
      "Username must be at least 3 characters",
    ),
    "usernameRequired": MessageLookupByLibrary.simpleMessage(
      "Username is required",
    ),
    "validEmailAddress": MessageLookupByLibrary.simpleMessage(
      "Enter a valid email address",
    ),
    "validPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "Enter a valid phone number",
    ),
    "verificationEmailSentTo": m2,
    "waitToResend": m3,
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back 👋"),
  };
}
