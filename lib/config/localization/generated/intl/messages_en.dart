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

  static String m1(count) => "${count} pending report(s) waiting to sync";

  static String m2(seconds) => "Resend in ${seconds} s";

  static String m3(email) =>
      "A verification link has been sent to:\n${email}\nPlease verify your account to continue.";

  static String m4(seconds) => "Wait ${seconds}s to Resend";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "address": MessageLookupByLibrary.simpleMessage("Address (Optional)"),
    "allowLocation": MessageLookupByLibrary.simpleMessage("Allow"),
    "appName": MessageLookupByLibrary.simpleMessage("PlantDoctor"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "AI Plant Disease Detection",
    ),
    "arabic": MessageLookupByLibrary.simpleMessage("Arabic"),
    "askPlantDoctor": MessageLookupByLibrary.simpleMessage(
      "Ask PlantDoctor...",
    ),
    "assistant": MessageLookupByLibrary.simpleMessage("Assistant"),
    "attachImage": MessageLookupByLibrary.simpleMessage(
      "Attach Image (Optional)",
    ),
    "attachedImage": MessageLookupByLibrary.simpleMessage("Attached Image"),
    "cacheError": MessageLookupByLibrary.simpleMessage(
      "An error occurred while caching. Please try again.",
    ),
    "camera": MessageLookupByLibrary.simpleMessage("Camera"),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "chatEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Take a photo of your plant or type\na question to get started.",
    ),
    "chatEmptyTitle": MessageLookupByLibrary.simpleMessage("Ask PlantDoctor"),
    "chatHistory": MessageLookupByLibrary.simpleMessage("Chat History"),
    "chooseFromGallery": MessageLookupByLibrary.simpleMessage(
      "Choose from Gallery",
    ),
    "confirmPassword": MessageLookupByLibrary.simpleMessage("Confirm Password"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create Account"),
    "createAccountDescription": MessageLookupByLibrary.simpleMessage(
      "Create your account to start detecting plant diseases instantly",
    ),
    "darkMode": MessageLookupByLibrary.simpleMessage("Dark Mode"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteChat": MessageLookupByLibrary.simpleMessage("Delete Chat"),
    "deleteChatConfirm": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete this chat?",
    ),
    "description": MessageLookupByLibrary.simpleMessage(
      "Describe your issue in detail",
    ),
    "descriptionMinLength": MessageLookupByLibrary.simpleMessage(
      "Description must be at least 10 characters",
    ),
    "descriptionRequired": MessageLookupByLibrary.simpleMessage(
      "Description is required",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Done"),
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
    "english": MessageLookupByLibrary.simpleMessage("English"),
    "errorModel": MessageLookupByLibrary.simpleMessage(
      "Failed to run classification. Please try again.",
    ),
    "fieldRequired": MessageLookupByLibrary.simpleMessage(
      "This field is required",
    ),
    "forceUpdateButton": MessageLookupByLibrary.simpleMessage(
      "Download Latest Version",
    ),
    "forceUpdateMessage": MessageLookupByLibrary.simpleMessage(
      "This version is no longer supported. Please download the latest version to continue using the app.",
    ),
    "forceUpdateRetry": MessageLookupByLibrary.simpleMessage(
      "Already updated? Tap to continue",
    ),
    "forceUpdateTitle": MessageLookupByLibrary.simpleMessage(
      "Update Required 🚨",
    ),
    "forceUpdateUrlError": MessageLookupByLibrary.simpleMessage(
      "Could not open the download link. Please contact support.",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage("Forgot Password?"),
    "forgotPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "Enter your email address and we will send you a link to reset your password.",
    ),
    "forgotYourPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot your password?",
    ),
    "fullName": MessageLookupByLibrary.simpleMessage("Full Name"),
    "gallery": MessageLookupByLibrary.simpleMessage("Gallery"),
    "iVerifiedMyEmail": MessageLookupByLibrary.simpleMessage(
      "I Verified My Email",
    ),
    "invalidCredential": MessageLookupByLibrary.simpleMessage(
      "Invalid email or password.",
    ),
    "joinPlantDoctor": MessageLookupByLibrary.simpleMessage(
      "Join PlantDoctor 🌱",
    ),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "lightMode": MessageLookupByLibrary.simpleMessage("Light Mode"),
    "locationPermissionMessage": MessageLookupByLibrary.simpleMessage(
      "We need your location to attach GPS coordinates to plant disease reports. This helps the Ministry of Agriculture track disease outbreaks across the country.",
    ),
    "locationPermissionTitle": MessageLookupByLibrary.simpleMessage(
      "Location Access Required",
    ),
    "locationServiceOffMessage": MessageLookupByLibrary.simpleMessage(
      "Please enable location services to attach your plant\'s location to the report.",
    ),
    "locationServiceOffTitle": MessageLookupByLibrary.simpleMessage(
      "Location Service Off",
    ),
    "micComingSoonAction": MessageLookupByLibrary.simpleMessage("Got it"),
    "micComingSoonContent": MessageLookupByLibrary.simpleMessage(
      "Voice input will be available in an upcoming release.",
    ),
    "micComingSoonTitle": MessageLookupByLibrary.simpleMessage("Coming Soon"),
    "ministry": MessageLookupByLibrary.simpleMessage("Ministry"),
    "newChat": MessageLookupByLibrary.simpleMessage("New Chat"),
    "noChatHistoryYet": MessageLookupByLibrary.simpleMessage(
      "No chat history yet",
    ),
    "noInternet": MessageLookupByLibrary.simpleMessage("No internet"),
    "notAuthenticated": MessageLookupByLibrary.simpleMessage(
      "No account found with this email. Please sign up first.",
    ),
    "offlineClassificationQueued": MessageLookupByLibrary.simpleMessage(
      "You\'re offline. Image classification was sent and saved locally. Results will sync automatically when you\'re back online.",
    ),
    "offlineDeleteError": MessageLookupByLibrary.simpleMessage(
      "Cannot delete while offline. Please connect to internet and try again.",
    ),
    "offlineError": MessageLookupByLibrary.simpleMessage(
      "You\'re offline. Please check your internet connection.",
    ),
    "offlinePromptError": MessageLookupByLibrary.simpleMessage(
      "You\'re offline. Only image diagnosis works without internet — text messages require a connection.",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("Open Settings"),
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
    "patchDialogButton": MessageLookupByLibrary.simpleMessage("Got it"),
    "patchDialogMessage": MessageLookupByLibrary.simpleMessage(
      "We fixed some issues and improved the app. Enjoy the latest version! 🎉",
    ),
    "patchDialogTitle": MessageLookupByLibrary.simpleMessage("App Updated"),
    "pendingReports": m1,
    "phoneNumber": MessageLookupByLibrary.simpleMessage("Phone Number"),
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
    "reportSavedOffline": MessageLookupByLibrary.simpleMessage(
      "Report saved. Will sync when online",
    ),
    "reportSavedOfflineSubtitle": MessageLookupByLibrary.simpleMessage(
      "You\'re currently offline. Your report will be sent automatically once you\'re back online.",
    ),
    "reportSavedOfflineTitle": MessageLookupByLibrary.simpleMessage(
      "Report Saved",
    ),
    "reportSubmittedSubtitle": MessageLookupByLibrary.simpleMessage(
      "Your report has been received. We\'ll get back to you as soon as possible.",
    ),
    "reportSubmittedSuccess": MessageLookupByLibrary.simpleMessage(
      "Report submitted successfully",
    ),
    "reportSubmittedTitle": MessageLookupByLibrary.simpleMessage(
      "Report Submitted",
    ),
    "reportWillBeSavedOffline": MessageLookupByLibrary.simpleMessage(
      "You\'re offline. Report will sync when connected",
    ),
    "resendEmail": MessageLookupByLibrary.simpleMessage("Resend Email"),
    "resendInSeconds": m2,
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "saveReport": MessageLookupByLibrary.simpleMessage("Save Report"),
    "selectImage": MessageLookupByLibrary.simpleMessage("Select Image"),
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
    "signOutConfirmMessage": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to sign out?",
    ),
    "signOutConfirmTitle": MessageLookupByLibrary.simpleMessage("Sign Out"),
    "signUp": MessageLookupByLibrary.simpleMessage("Sign Up"),
    "startAChatToGetPlantCareAdvice": MessageLookupByLibrary.simpleMessage(
      "Start a chat to get plant care advice",
    ),
    "submitReport": MessageLookupByLibrary.simpleMessage("Submit Report"),
    "syncFailedOffline": MessageLookupByLibrary.simpleMessage(
      "Couldn\'t sync — check your connection",
    ),
    "syncNow": MessageLookupByLibrary.simpleMessage("Sync now"),
    "syncingReports": MessageLookupByLibrary.simpleMessage("Syncing..."),
    "takePhoto": MessageLookupByLibrary.simpleMessage("Take Photo"),
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
    "verificationEmailSentTo": m3,
    "waitToResend": m4,
    "waitingForLocation": MessageLookupByLibrary.simpleMessage(
      "Waiting for location...",
    ),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome Back 👋"),
    "yesterday": MessageLookupByLibrary.simpleMessage("Yesterday"),
  };
}
