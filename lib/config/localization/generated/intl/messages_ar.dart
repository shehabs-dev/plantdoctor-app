// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(requirements) => "يجب أن تحتوي على: ${requirements}";

  static String m1(seconds) => "إعادة الإرسال خلال ${seconds} ثانية";

  static String m2(email) =>
      "تم إرسال رابط التحقق إلى:\n${email}\nيرجى التحقق من حسابك للمتابعة.";

  static String m3(seconds) => "انتظر ${seconds} ثانية لإعادة الإرسال";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "appName": MessageLookupByLibrary.simpleMessage("PlantDoctor"),
    "appTagline": MessageLookupByLibrary.simpleMessage(
      "اكتشاف أمراض النباتات بالذكاء الاصطناعي",
    ),
    "assistant": MessageLookupByLibrary.simpleMessage("المساعد"),
    "confirmPassword": MessageLookupByLibrary.simpleMessage(
      "تأكيد كلمة المرور",
    ),
    "createAccount": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "createAccountDescription": MessageLookupByLibrary.simpleMessage(
      "أنشئ حسابك لبدء اكتشاف أمراض النباتات فورًا",
    ),
    "dontHaveAnAccount": MessageLookupByLibrary.simpleMessage("ليس لديك حساب؟"),
    "email": MessageLookupByLibrary.simpleMessage("البريد الإلكتروني"),
    "emailAddress": MessageLookupByLibrary.simpleMessage(
      "عنوان البريد الإلكتروني",
    ),
    "emailAlreadyInUse": MessageLookupByLibrary.simpleMessage(
      "يوجد حساب بهذا البريد الإلكتروني بالفعل.",
    ),
    "emailNotVerified": MessageLookupByLibrary.simpleMessage(
      "لم يتم التحقق من بريدك الإلكتروني بعد.",
    ),
    "emailRequired": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني مطلوب",
    ),
    "emailVerificationSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رسالة تحقق إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد.",
    ),
    "forgotPassword": MessageLookupByLibrary.simpleMessage(
      "هل نسيت كلمة المرور؟",
    ),
    "forgotPasswordDescription": MessageLookupByLibrary.simpleMessage(
      "أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.",
    ),
    "forgotYourPassword": MessageLookupByLibrary.simpleMessage(
      "هل نسيت كلمة المرور؟",
    ),
    "fullName": MessageLookupByLibrary.simpleMessage("الاسم الكامل"),
    "iVerifiedMyEmail": MessageLookupByLibrary.simpleMessage(
      "لقد قمت بتأكيد بريدي الإلكتروني",
    ),
    "invalidCredential": MessageLookupByLibrary.simpleMessage(
      "البريد الإلكتروني أو كلمة المرور غير صحيحة.",
    ),
    "joinPlantDoctor": MessageLookupByLibrary.simpleMessage(
      "انضم إلى PlantDoctor 🌱",
    ),
    "ministry": MessageLookupByLibrary.simpleMessage("الوزارة"),
    "noChatHistoryYet": MessageLookupByLibrary.simpleMessage(
      "لا يوجد سجل محادثات بعد",
    ),
    "notAuthenticated": MessageLookupByLibrary.simpleMessage(
      "لم يتم العثور على حساب بهذا البريد الإلكتروني. يرجى إنشاء حساب أولاً.",
    ),
    "offlineError": MessageLookupByLibrary.simpleMessage(
      "أنت غير متصل بالإنترنت. يرجى التحقق من اتصالك.",
    ),
    "or": MessageLookupByLibrary.simpleMessage("أو"),
    "password": MessageLookupByLibrary.simpleMessage("كلمة المرور"),
    "passwordInclude": m0,
    "passwordRequired": MessageLookupByLibrary.simpleMessage(
      "كلمة المرور مطلوبة",
    ),
    "passwordRequirementChars": MessageLookupByLibrary.simpleMessage(
      "6 أحرف أو أكثر",
    ),
    "passwordRequirementLowercase": MessageLookupByLibrary.simpleMessage(
      "حرف صغير",
    ),
    "passwordRequirementNumber": MessageLookupByLibrary.simpleMessage("رقم"),
    "passwordRequirementUppercase": MessageLookupByLibrary.simpleMessage(
      "حرف كبير",
    ),
    "passwordResetSent": MessageLookupByLibrary.simpleMessage(
      "تم إرسال رسالة إعادة تعيين كلمة المرور إلى بريدك الإلكتروني. يرجى التحقق من صندوق الوارد لإعادة التعيين.",
    ),
    "passwordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "كلمتا المرور غير متطابقتين",
    ),
    "phoneRequired": MessageLookupByLibrary.simpleMessage("رقم الهاتف مطلوب"),
    "postAddedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تمت إضافة المنشور بنجاح",
    ),
    "postDeletedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم حذف المنشور بنجاح",
    ),
    "postUpdatedSuccessfully": MessageLookupByLibrary.simpleMessage(
      "تم تحديث المنشور بنجاح",
    ),
    "report": MessageLookupByLibrary.simpleMessage("التقرير"),
    "resendEmail": MessageLookupByLibrary.simpleMessage("إعادة إرسال البريد"),
    "resendInSeconds": m1,
    "sendResetLink": MessageLookupByLibrary.simpleMessage(
      "إرسال رابط إعادة التعيين",
    ),
    "sending": MessageLookupByLibrary.simpleMessage("جارٍ الإرسال..."),
    "serverError": MessageLookupByLibrary.simpleMessage(
      "نواجه مشكلة في الاتصال بالخادم. يرجى المحاولة مرة أخرى.",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInAborted": MessageLookupByLibrary.simpleMessage(
      "تم إلغاء تسجيل الدخول.",
    ),
    "signInWithApple": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام Apple",
    ),
    "signInWithFacebook": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام Facebook",
    ),
    "signInWithGitHub": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام GitHub",
    ),
    "signInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام Google",
    ),
    "signInWithLinkedIn": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام LinkedIn",
    ),
    "signInWithMicrosoft": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام Microsoft",
    ),
    "signInWithX": MessageLookupByLibrary.simpleMessage(
      "تسجيل الدخول باستخدام X",
    ),
    "signOut": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "signUp": MessageLookupByLibrary.simpleMessage("إنشاء حساب"),
    "tooManyRequests": MessageLookupByLibrary.simpleMessage(
      "عدد المحاولات كبير جدًا. يرجى المحاولة لاحقًا.",
    ),
    "unexpectedError": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يرجى المحاولة مرة أخرى.",
    ),
    "usernameMinLength": MessageLookupByLibrary.simpleMessage(
      "يجب أن يكون اسم المستخدم 3 أحرف على الأقل",
    ),
    "usernameRequired": MessageLookupByLibrary.simpleMessage(
      "اسم المستخدم مطلوب",
    ),
    "validEmailAddress": MessageLookupByLibrary.simpleMessage(
      "أدخل بريدًا إلكترونيًا صحيحًا",
    ),
    "validPhoneNumber": MessageLookupByLibrary.simpleMessage(
      "أدخل رقم هاتف صحيح",
    ),
    "verificationEmailSentTo": m2,
    "waitToResend": m3,
    "welcomeBack": MessageLookupByLibrary.simpleMessage("مرحبًا بعودتك 👋"),
  };
}
