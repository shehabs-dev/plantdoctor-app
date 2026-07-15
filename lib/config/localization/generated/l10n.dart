// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `PlantDoctor`
  String get appName {
    return Intl.message('PlantDoctor', name: 'appName', desc: '', args: []);
  }

  /// `AI Plant Disease Detection`
  String get appTagline {
    return Intl.message(
      'AI Plant Disease Detection',
      name: 'appTagline',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back 👋`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back 👋',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Join PlantDoctor 🌱`
  String get joinPlantDoctor {
    return Intl.message(
      'Join PlantDoctor 🌱',
      name: 'joinPlantDoctor',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message('Sign In', name: 'signIn', desc: '', args: []);
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Sign Out`
  String get signOut {
    return Intl.message('Sign Out', name: 'signOut', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message('Full Name', name: 'fullName', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address and we will send you a link to reset your password.`
  String get forgotPasswordDescription {
    return Intl.message(
      'Enter your email address and we will send you a link to reset your password.',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send Reset Link`
  String get sendResetLink {
    return Intl.message(
      'Send Reset Link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Resend in {seconds} s`
  String resendInSeconds(Object seconds) {
    return Intl.message(
      'Resend in $seconds s',
      name: 'resendInSeconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `Create your account to start detecting plant diseases instantly`
  String get createAccountDescription {
    return Intl.message(
      'Create your account to start detecting plant diseases instantly',
      name: 'createAccountDescription',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message('or', name: 'or', desc: '', args: []);
  }

  /// `A verification link has been sent to:\n{email}\nPlease verify your account to continue.`
  String verificationEmailSentTo(Object email) {
    return Intl.message(
      'A verification link has been sent to:\n$email\nPlease verify your account to continue.',
      name: 'verificationEmailSentTo',
      desc: '',
      args: [email],
    );
  }

  /// `Sending...`
  String get sending {
    return Intl.message('Sending...', name: 'sending', desc: '', args: []);
  }

  /// `Resend Email`
  String get resendEmail {
    return Intl.message(
      'Resend Email',
      name: 'resendEmail',
      desc: '',
      args: [],
    );
  }

  /// `Wait {seconds}s to Resend`
  String waitToResend(Object seconds) {
    return Intl.message(
      'Wait ${seconds}s to Resend',
      name: 'waitToResend',
      desc: '',
      args: [seconds],
    );
  }

  /// `I Verified My Email`
  String get iVerifiedMyEmail {
    return Intl.message(
      'I Verified My Email',
      name: 'iVerifiedMyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get signInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'signInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Apple`
  String get signInWithApple {
    return Intl.message(
      'Sign in with Apple',
      name: 'signInWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Facebook`
  String get signInWithFacebook {
    return Intl.message(
      'Sign in with Facebook',
      name: 'signInWithFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with GitHub`
  String get signInWithGitHub {
    return Intl.message(
      'Sign in with GitHub',
      name: 'signInWithGitHub',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with X`
  String get signInWithX {
    return Intl.message(
      'Sign in with X',
      name: 'signInWithX',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with LinkedIn`
  String get signInWithLinkedIn {
    return Intl.message(
      'Sign in with LinkedIn',
      name: 'signInWithLinkedIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Microsoft`
  String get signInWithMicrosoft {
    return Intl.message(
      'Sign in with Microsoft',
      name: 'signInWithMicrosoft',
      desc: '',
      args: [],
    );
  }

  /// `We're having trouble connecting to the server. Please try again.`
  String get serverError {
    return Intl.message(
      'We\'re having trouble connecting to the server. Please try again.',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `You're offline. Please check your internet connection.`
  String get offlineError {
    return Intl.message(
      'You\'re offline. Please check your internet connection.',
      name: 'offlineError',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again.`
  String get unexpectedError {
    return Intl.message(
      'Something went wrong. Please try again.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// `An account with this email already exists.`
  String get emailAlreadyInUse {
    return Intl.message(
      'An account with this email already exists.',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password.`
  String get invalidCredential {
    return Intl.message(
      'Invalid email or password.',
      name: 'invalidCredential',
      desc: '',
      args: [],
    );
  }

  /// `No account found with this email. Please sign up first.`
  String get notAuthenticated {
    return Intl.message(
      'No account found with this email. Please sign up first.',
      name: 'notAuthenticated',
      desc: '',
      args: [],
    );
  }

  /// `Sign in was cancelled.`
  String get signInAborted {
    return Intl.message(
      'Sign in was cancelled.',
      name: 'signInAborted',
      desc: '',
      args: [],
    );
  }

  /// `Your email has not been verified yet.`
  String get emailNotVerified {
    return Intl.message(
      'Your email has not been verified yet.',
      name: 'emailNotVerified',
      desc: '',
      args: [],
    );
  }

  /// `Too many attempts. Please try again later.`
  String get tooManyRequests {
    return Intl.message(
      'Too many attempts. Please try again later.',
      name: 'tooManyRequests',
      desc: '',
      args: [],
    );
  }

  /// `A verification email has been sent. Please check your inbox.`
  String get emailVerificationSent {
    return Intl.message(
      'A verification email has been sent. Please check your inbox.',
      name: 'emailVerificationSent',
      desc: '',
      args: [],
    );
  }

  /// `A password reset email has been sent. Please check your inbox to reset your password.`
  String get passwordResetSent {
    return Intl.message(
      'A password reset email has been sent. Please check your inbox to reset your password.',
      name: 'passwordResetSent',
      desc: '',
      args: [],
    );
  }

  /// `Post added successfully`
  String get postAddedSuccessfully {
    return Intl.message(
      'Post added successfully',
      name: 'postAddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Post deleted successfully`
  String get postDeletedSuccessfully {
    return Intl.message(
      'Post deleted successfully',
      name: 'postDeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Post updated successfully`
  String get postUpdatedSuccessfully {
    return Intl.message(
      'Post updated successfully',
      name: 'postUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Username is required`
  String get usernameRequired {
    return Intl.message(
      'Username is required',
      name: 'usernameRequired',
      desc: '',
      args: [],
    );
  }

  /// `Password is required`
  String get passwordRequired {
    return Intl.message(
      'Password is required',
      name: 'passwordRequired',
      desc: '',
      args: [],
    );
  }

  /// `Email is required`
  String get emailRequired {
    return Intl.message(
      'Email is required',
      name: 'emailRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description is required`
  String get descriptionRequired {
    return Intl.message(
      'Description is required',
      name: 'descriptionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Phone number is required`
  String get phoneRequired {
    return Intl.message(
      'Phone number is required',
      name: 'phoneRequired',
      desc: '',
      args: [],
    );
  }

  /// `Description must be at least 10 characters`
  String get descriptionMinLength {
    return Intl.message(
      'Description must be at least 10 characters',
      name: 'descriptionMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Username must be at least 3 characters`
  String get usernameMinLength {
    return Intl.message(
      'Username must be at least 3 characters',
      name: 'usernameMinLength',
      desc: '',
      args: [],
    );
  }

  /// `Include: {requirements}`
  String passwordInclude(Object requirements) {
    return Intl.message(
      'Include: $requirements',
      name: 'passwordInclude',
      desc: '',
      args: [requirements],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid phone number`
  String get validPhoneNumber {
    return Intl.message(
      'Enter a valid phone number',
      name: 'validPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter a valid email address`
  String get validEmailAddress {
    return Intl.message(
      'Enter a valid email address',
      name: 'validEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `6+ chars`
  String get passwordRequirementChars {
    return Intl.message(
      '6+ chars',
      name: 'passwordRequirementChars',
      desc: '',
      args: [],
    );
  }

  /// `uppercase`
  String get passwordRequirementUppercase {
    return Intl.message(
      'uppercase',
      name: 'passwordRequirementUppercase',
      desc: '',
      args: [],
    );
  }

  /// `lowercase`
  String get passwordRequirementLowercase {
    return Intl.message(
      'lowercase',
      name: 'passwordRequirementLowercase',
      desc: '',
      args: [],
    );
  }

  /// `number`
  String get passwordRequirementNumber {
    return Intl.message(
      'number',
      name: 'passwordRequirementNumber',
      desc: '',
      args: [],
    );
  }

  /// `Assistant`
  String get assistant {
    return Intl.message('Assistant', name: 'assistant', desc: '', args: []);
  }

  /// `Chat History`
  String get chatHistory {
    return Intl.message(
      'Chat History',
      name: 'chatHistory',
      desc: '',
      args: [],
    );
  }

  /// `Report`
  String get report {
    return Intl.message('Report', name: 'report', desc: '', args: []);
  }

  /// `Ministry`
  String get ministry {
    return Intl.message('Ministry', name: 'ministry', desc: '', args: []);
  }

  /// `No chat history yet`
  String get noChatHistoryYet {
    return Intl.message(
      'No chat history yet',
      name: 'noChatHistoryYet',
      desc: '',
      args: [],
    );
  }

  /// `Failed to run classification. Please try again.`
  String get errorModel {
    return Intl.message(
      'Failed to run classification. Please try again.',
      name: 'errorModel',
      desc: '',
      args: [],
    );
  }

  /// `Location Access Required`
  String get locationPermissionTitle {
    return Intl.message(
      'Location Access Required',
      name: 'locationPermissionTitle',
      desc: '',
      args: [],
    );
  }

  /// `We need your location to attach GPS coordinates to plant disease reports. This helps the Ministry of Agriculture track disease outbreaks across the country.`
  String get locationPermissionMessage {
    return Intl.message(
      'We need your location to attach GPS coordinates to plant disease reports. This helps the Ministry of Agriculture track disease outbreaks across the country.',
      name: 'locationPermissionMessage',
      desc: '',
      args: [],
    );
  }

  /// `Allow`
  String get allowLocation {
    return Intl.message('Allow', name: 'allowLocation', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `New Chat`
  String get newChat {
    return Intl.message('New Chat', name: 'newChat', desc: '', args: []);
  }

  /// `Ask PlantDoctor`
  String get chatEmptyTitle {
    return Intl.message(
      'Ask PlantDoctor',
      name: 'chatEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Take a photo of your plant or type\na question to get started.`
  String get chatEmptySubtitle {
    return Intl.message(
      'Take a photo of your plant or type\na question to get started.',
      name: 'chatEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get micComingSoonTitle {
    return Intl.message(
      'Coming Soon',
      name: 'micComingSoonTitle',
      desc: '',
      args: [],
    );
  }

  /// `Voice input will be available in an upcoming release.`
  String get micComingSoonContent {
    return Intl.message(
      'Voice input will be available in an upcoming release.',
      name: 'micComingSoonContent',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get micComingSoonAction {
    return Intl.message(
      'Got it',
      name: 'micComingSoonAction',
      desc: '',
      args: [],
    );
  }

  /// `Location Service Off`
  String get locationServiceOffTitle {
    return Intl.message(
      'Location Service Off',
      name: 'locationServiceOffTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enable location services to attach your plant's location to the report.`
  String get locationServiceOffMessage {
    return Intl.message(
      'Please enable location services to attach your plant\'s location to the report.',
      name: 'locationServiceOffMessage',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings`
  String get openSettings {
    return Intl.message(
      'Open Settings',
      name: 'openSettings',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Delete Chat`
  String get deleteChat {
    return Intl.message('Delete Chat', name: 'deleteChat', desc: '', args: []);
  }

  /// `Are you sure you want to delete this chat?`
  String get deleteChatConfirm {
    return Intl.message(
      'Are you sure you want to delete this chat?',
      name: 'deleteChatConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Dark Mode`
  String get darkMode {
    return Intl.message('Dark Mode', name: 'darkMode', desc: '', args: []);
  }

  /// `Light Mode`
  String get lightMode {
    return Intl.message('Light Mode', name: 'lightMode', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Start a chat to get plant care advice`
  String get startAChatToGetPlantCareAdvice {
    return Intl.message(
      'Start a chat to get plant care advice',
      name: 'startAChatToGetPlantCareAdvice',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `Address (Optional)`
  String get address {
    return Intl.message(
      'Address (Optional)',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `Ask PlantDoctor...`
  String get askPlantDoctor {
    return Intl.message(
      'Ask PlantDoctor...',
      name: 'askPlantDoctor',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred while caching. Please try again.`
  String get cacheError {
    return Intl.message(
      'An error occurred while caching. Please try again.',
      name: 'cacheError',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for location...`
  String get waitingForLocation {
    return Intl.message(
      'Waiting for location...',
      name: 'waitingForLocation',
      desc: '',
      args: [],
    );
  }

  /// `Describe your issue in detail`
  String get description {
    return Intl.message(
      'Describe your issue in detail',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Attach Image (Optional)`
  String get attachImage {
    return Intl.message(
      'Attach Image (Optional)',
      name: 'attachImage',
      desc: '',
      args: [],
    );
  }

  /// `Attached Image`
  String get attachedImage {
    return Intl.message(
      'Attached Image',
      name: 'attachedImage',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message('Camera', name: 'camera', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Submit Report`
  String get submitReport {
    return Intl.message(
      'Submit Report',
      name: 'submitReport',
      desc: '',
      args: [],
    );
  }

  /// `Save Report`
  String get saveReport {
    return Intl.message('Save Report', name: 'saveReport', desc: '', args: []);
  }

  /// `Report submitted successfully`
  String get reportSubmittedSuccess {
    return Intl.message(
      'Report submitted successfully',
      name: 'reportSubmittedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Report saved. Will sync when online`
  String get reportSavedOffline {
    return Intl.message(
      'Report saved. Will sync when online',
      name: 'reportSavedOffline',
      desc: '',
      args: [],
    );
  }

  /// `You're offline. Report will sync when connected`
  String get reportWillBeSavedOffline {
    return Intl.message(
      'You\'re offline. Report will sync when connected',
      name: 'reportWillBeSavedOffline',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get fieldRequired {
    return Intl.message(
      'This field is required',
      name: 'fieldRequired',
      desc: '',
      args: [],
    );
  }

  /// `{count} pending report(s) waiting to sync`
  String pendingReports(int count) {
    return Intl.message(
      '$count pending report(s) waiting to sync',
      name: 'pendingReports',
      desc: '',
      args: [count],
    );
  }

  /// `You're offline. Only image diagnosis works without internet — text messages require a connection.`
  String get offlinePromptError {
    return Intl.message(
      'You\'re offline. Only image diagnosis works without internet — text messages require a connection.',
      name: 'offlinePromptError',
      desc: 'Error shown when user tries to send text message while offline',
      args: [],
    );
  }

  /// `You're offline. Image classification was sent and saved locally. Results will sync automatically when you're back online.`
  String get offlineClassificationQueued {
    return Intl.message(
      'You\'re offline. Image classification was sent and saved locally. Results will sync automatically when you\'re back online.',
      name: 'offlineClassificationQueued',
      desc: 'Info shown when user sends image for classification while offline',
      args: [],
    );
  }

  /// `Cannot delete while offline. Please connect to internet and try again.`
  String get offlineDeleteError {
    return Intl.message(
      'Cannot delete while offline. Please connect to internet and try again.',
      name: 'offlineDeleteError',
      desc: '',
      args: [],
    );
  }

  /// `Report Submitted`
  String get reportSubmittedTitle {
    return Intl.message(
      'Report Submitted',
      name: 'reportSubmittedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your report has been received. We'll get back to you as soon as possible.`
  String get reportSubmittedSubtitle {
    return Intl.message(
      'Your report has been received. We\'ll get back to you as soon as possible.',
      name: 'reportSubmittedSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Report Saved`
  String get reportSavedOfflineTitle {
    return Intl.message(
      'Report Saved',
      name: 'reportSavedOfflineTitle',
      desc: '',
      args: [],
    );
  }

  /// `You're currently offline. Your report will be sent automatically once you're back online.`
  String get reportSavedOfflineSubtitle {
    return Intl.message(
      'You\'re currently offline. Your report will be sent automatically once you\'re back online.',
      name: 'reportSavedOfflineSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Select Image`
  String get selectImage {
    return Intl.message(
      'Select Image',
      name: 'selectImage',
      desc: '',
      args: [],
    );
  }

  /// `No internet`
  String get noInternet {
    return Intl.message('No internet', name: 'noInternet', desc: '', args: []);
  }

  /// `Sign Out`
  String get signOutConfirmTitle {
    return Intl.message(
      'Sign Out',
      name: 'signOutConfirmTitle',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to sign out?`
  String get signOutConfirmMessage {
    return Intl.message(
      'Are you sure you want to sign out?',
      name: 'signOutConfirmMessage',
      desc: '',
      args: [],
    );
  }

  /// `App Updated`
  String get patchDialogTitle {
    return Intl.message(
      'App Updated',
      name: 'patchDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `We fixed some issues and improved the app. Enjoy the latest version! 🎉`
  String get patchDialogMessage {
    return Intl.message(
      'We fixed some issues and improved the app. Enjoy the latest version! 🎉',
      name: 'patchDialogMessage',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get patchDialogButton {
    return Intl.message(
      'Got it',
      name: 'patchDialogButton',
      desc: '',
      args: [],
    );
  }

  /// `Update Required 🚨`
  String get forceUpdateTitle {
    return Intl.message(
      'Update Required 🚨',
      name: 'forceUpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `This version is no longer supported. Please download the latest version to continue using the app.`
  String get forceUpdateMessage {
    return Intl.message(
      'This version is no longer supported. Please download the latest version to continue using the app.',
      name: 'forceUpdateMessage',
      desc: '',
      args: [],
    );
  }

  /// `Download Latest Version`
  String get forceUpdateButton {
    return Intl.message(
      'Download Latest Version',
      name: 'forceUpdateButton',
      desc: '',
      args: [],
    );
  }

  /// `Could not open the download link. Please contact support.`
  String get forceUpdateUrlError {
    return Intl.message(
      'Could not open the download link. Please contact support.',
      name: 'forceUpdateUrlError',
      desc: '',
      args: [],
    );
  }

  /// `Already updated? Tap to continue`
  String get forceUpdateRetry {
    return Intl.message(
      'Already updated? Tap to continue',
      name: 'forceUpdateRetry',
      desc: '',
      args: [],
    );
  }

  /// `Sync now`
  String get syncNow {
    return Intl.message('Sync now', name: 'syncNow', desc: '', args: []);
  }

  /// `Syncing...`
  String get syncingReports {
    return Intl.message(
      'Syncing...',
      name: 'syncingReports',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't sync — check your connection`
  String get syncFailedOffline {
    return Intl.message(
      'Couldn\'t sync — check your connection',
      name: 'syncFailedOffline',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
