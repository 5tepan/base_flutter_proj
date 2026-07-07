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

  static String m0(phone) =>
      "An SMS with a confirmation code\nwas sent to ${phone}";

  static String m1(path) => "Saved: ${path}";

  static String m2(current, total) => "${current} / ${total}";

  static String m3(buttonText) =>
      "By tapping «${buttonText}», you agree to the ";

  static String m4(time) => "Resend in ${time}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "apiBadRequestFormat": MessageLookupByLibrary.simpleMessage(
      "Invalid request format",
    ),
    "apiConnectionError": MessageLookupByLibrary.simpleMessage(
      "Internet connection error",
    ),
    "apiDataNotFound": MessageLookupByLibrary.simpleMessage("Data not found"),
    "apiInvalidJson": MessageLookupByLibrary.simpleMessage(
      "Server response is not valid JSON",
    ),
    "apiInvalidMeta": MessageLookupByLibrary.simpleMessage(
      "Failed to parse meta from response",
    ),
    "apiMissingData": MessageLookupByLibrary.simpleMessage(
      "Failed to read data from response",
    ),
    "apiMissingMeta": MessageLookupByLibrary.simpleMessage(
      "Failed to read meta from response",
    ),
    "apiNoInternet": MessageLookupByLibrary.simpleMessage(
      "No internet. Please try again later.",
    ),
    "apiParseError": MessageLookupByLibrary.simpleMessage(
      "An error occurred. Please try again later.",
    ),
    "apiRequestFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to send request. Please try again",
    ),
    "apiUnknownError": MessageLookupByLibrary.simpleMessage(
      "Unknown error. Please try again later",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Base Flutter"),
    "authConfirmCodeError": MessageLookupByLibrary.simpleMessage(
      "Failed to verify code. Please try again later",
    ),
    "authInvalidConfirmationCode": MessageLookupByLibrary.simpleMessage(
      "Invalid confirmation code",
    ),
    "authPhoneRequired": MessageLookupByLibrary.simpleMessage(
      "Enter phone number",
    ),
    "authPhoneTitle": MessageLookupByLibrary.simpleMessage(
      "Enter your phone number\nto receive a confirmation code",
    ),
    "authRefreshSessionFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to refresh session",
    ),
    "authResendCodeError": MessageLookupByLibrary.simpleMessage(
      "Failed to resend code",
    ),
    "authResendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to resend code",
    ),
    "authSendCodeError": MessageLookupByLibrary.simpleMessage(
      "Failed to send code. Please try again later",
    ),
    "authSendCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to send code",
    ),
    "authSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Session expired. Please sign in again",
    ),
    "authVerifyCodeFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to verify code",
    ),
    "chatEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Send the first message",
    ),
    "chatEmptyTitle": MessageLookupByLibrary.simpleMessage("No messages"),
    "chatListEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Your conversations will appear here",
    ),
    "chatListEmptyTitle": MessageLookupByLibrary.simpleMessage("No chats"),
    "chatListTitle": MessageLookupByLibrary.simpleMessage("Chats"),
    "chatMessageInputHint": MessageLookupByLibrary.simpleMessage("Message"),
    "codeSentToPhone": m0,
    "confirmationCodeLabel": MessageLookupByLibrary.simpleMessage(
      "Confirmation code",
    ),
    "continueButton": MessageLookupByLibrary.simpleMessage("Continue"),
    "dateTimeSelect": MessageLookupByLibrary.simpleMessage("Select"),
    "dateTimeSelectTime": MessageLookupByLibrary.simpleMessage("Select time"),
    "dateTimeSelectYear": MessageLookupByLibrary.simpleMessage("Select year"),
    "demoAttachmentsLabel": MessageLookupByLibrary.simpleMessage("Attachments"),
    "demoCalendarListMode": MessageLookupByLibrary.simpleMessage("Month list"),
    "demoCalendarPageMode": MessageLookupByLibrary.simpleMessage("PageView"),
    "demoCalendarSubtitle": MessageLookupByLibrary.simpleMessage(
      "Swipe between months and pick a date range. Switch mode from the AppBar menu.",
    ),
    "demoCalendarTitle": MessageLookupByLibrary.simpleMessage("Calendar"),
    "demoFilesSectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "PDF, documents and other types via file_picker.",
    ),
    "demoFilesSectionTitle": MessageLookupByLibrary.simpleMessage(
      "File upload",
    ),
    "demoMediaFilesTitle": MessageLookupByLibrary.simpleMessage(
      "Media and files",
    ),
    "demoMixedSectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Mixed feed. Camera: photo or video; gallery: any type.",
    ),
    "demoMixedSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Photos and videos (mixed)",
    ),
    "demoPhotoSectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Images only. Croppy opens when adding a photo.",
    ),
    "demoPhotoSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Photos (editable feed)",
    ),
    "demoReadOnlySectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Same items as the mixed feed, without add or remove.",
    ),
    "demoReadOnlySectionTitle": MessageLookupByLibrary.simpleMessage(
      "View only",
    ),
    "demoShareFilesButton": MessageLookupByLibrary.simpleMessage("Share files"),
    "demoShareLinkText": MessageLookupByLibrary.simpleMessage(
      "Demo link from the app",
    ),
    "demoShareSectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "share_plus — link, text and selected files.",
    ),
    "demoShareSectionTitle": MessageLookupByLibrary.simpleMessage("Sharing"),
    "demoShareTextButton": MessageLookupByLibrary.simpleMessage("Share text"),
    "demoSyncMixedButton": MessageLookupByLibrary.simpleMessage(
      "Copy mixed feed to view-only mode",
    ),
    "documentDefaultTitle": MessageLookupByLibrary.simpleMessage("Document"),
    "enterCode": MessageLookupByLibrary.simpleMessage("Enter the code"),
    "enterPhone": MessageLookupByLibrary.simpleMessage("Enter phone number"),
    "errorLoadingText": MessageLookupByLibrary.simpleMessage(
      "Data could not be loaded. Please try again.",
    ),
    "errorLoadingTitle": MessageLookupByLibrary.simpleMessage(
      "Failed to load data",
    ),
    "fileAudioPause": MessageLookupByLibrary.simpleMessage("Pause"),
    "fileAudioPlay": MessageLookupByLibrary.simpleMessage("Play"),
    "fileListEmpty": MessageLookupByLibrary.simpleMessage("No files selected"),
    "filePickButton": MessageLookupByLibrary.simpleMessage("Choose files"),
    "filePickError": MessageLookupByLibrary.simpleMessage(
      "Failed to choose files",
    ),
    "fileViewerLocalUnavailable": MessageLookupByLibrary.simpleMessage(
      "Local file unavailable",
    ),
    "fileViewerMediaTitle": MessageLookupByLibrary.simpleMessage("Media"),
    "fileViewerPreviewUnavailable": MessageLookupByLibrary.simpleMessage(
      "Preview unavailable",
    ),
    "fileViewerSaveFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to save file",
    ),
    "fileViewerSaved": m1,
    "fileViewerTitle": MessageLookupByLibrary.simpleMessage("File"),
    "inDevelopment": MessageLookupByLibrary.simpleMessage("In development"),
    "mediaFeedAddTitle": MessageLookupByLibrary.simpleMessage("Add media"),
    "mediaFeedCamera": MessageLookupByLibrary.simpleMessage("Camera"),
    "mediaFeedGallery": MessageLookupByLibrary.simpleMessage("Gallery"),
    "mediaFeedGalleryClose": MessageLookupByLibrary.simpleMessage("Close"),
    "mediaFeedGalleryCounter": m2,
    "mediaFeedPhoto": MessageLookupByLibrary.simpleMessage("Photo"),
    "mediaFeedVideo": MessageLookupByLibrary.simpleMessage("Video"),
    "navHome": MessageLookupByLibrary.simpleMessage("Home"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Profile"),
    "navShop": MessageLookupByLibrary.simpleMessage("Shop"),
    "noInternet": MessageLookupByLibrary.simpleMessage(
      "You are offline. Check your internet connection.",
    ),
    "phoneInvalid": MessageLookupByLibrary.simpleMessage(
      "Enter a valid phone number",
    ),
    "phoneLabel": MessageLookupByLibrary.simpleMessage("Phone"),
    "privacyAgreementAnd": MessageLookupByLibrary.simpleMessage("\nand "),
    "privacyAgreementPrefix": m3,
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "privacyPolicyTitle": MessageLookupByLibrary.simpleMessage(
      "Privacy Policy",
    ),
    "profileCalendarDemoSubtitle": MessageLookupByLibrary.simpleMessage(
      "Custom calendar: range selection, markers, list/page modes",
    ),
    "profileCalendarDemoTitle": MessageLookupByLibrary.simpleMessage(
      "Calendar",
    ),
    "profileChatDemoSubtitle": MessageLookupByLibrary.simpleMessage(
      "Room list, messages, real-time WebSocket updates",
    ),
    "profileChatDemoTitle": MessageLookupByLibrary.simpleMessage("Chats"),
    "profileChatDirectDemoSubtitle": MessageLookupByLibrary.simpleMessage(
      "Open the single chat directly, without the room list",
    ),
    "profileChatDirectDemoTitle": MessageLookupByLibrary.simpleMessage("Chat"),
    "profileDemoSectionSubtitle": MessageLookupByLibrary.simpleMessage(
      "Examples from core/components",
    ),
    "profileDemoSectionTitle": MessageLookupByLibrary.simpleMessage(
      "Component demos",
    ),
    "profileMediaDemoSubtitle": MessageLookupByLibrary.simpleMessage(
      "Photo/video feed, file upload, preview, sharing",
    ),
    "profileMediaDemoTitle": MessageLookupByLibrary.simpleMessage(
      "Media and files",
    ),
    "resendCodeButton": MessageLookupByLibrary.simpleMessage("Resend code"),
    "resendCodeIn": m4,
    "shareButton": MessageLookupByLibrary.simpleMessage("Share"),
    "shareLinkButton": MessageLookupByLibrary.simpleMessage("Share link"),
    "shopEmptySubtitle": MessageLookupByLibrary.simpleMessage(
      "Products will appear here",
    ),
    "shopEmptyTitle": MessageLookupByLibrary.simpleMessage("Nothing here yet"),
    "shopLayoutGrid": MessageLookupByLibrary.simpleMessage("Grid"),
    "shopLayoutList": MessageLookupByLibrary.simpleMessage("List"),
    "shopProductDescription": MessageLookupByLibrary.simpleMessage(
      "Description",
    ),
    "shopProductDetailTitle": MessageLookupByLibrary.simpleMessage("Product"),
    "shopTitle": MessageLookupByLibrary.simpleMessage("Shop"),
    "termsOfUse": MessageLookupByLibrary.simpleMessage("Terms of Use"),
    "termsOfUseTitle": MessageLookupByLibrary.simpleMessage("Terms of Use"),
    "tryAgain": MessageLookupByLibrary.simpleMessage("Try again"),
    "universalModalNo": MessageLookupByLibrary.simpleMessage("No"),
    "universalModalOk": MessageLookupByLibrary.simpleMessage("OK"),
    "universalModalYes": MessageLookupByLibrary.simpleMessage("Yes"),
    "validationDateOfBirth": MessageLookupByLibrary.simpleMessage(
      "Select date of birth",
    ),
    "validationEmailInvalid": MessageLookupByLibrary.simpleMessage(
      "Invalid e-mail",
    ),
    "validationEmailRequired": MessageLookupByLibrary.simpleMessage(
      "Enter e-mail",
    ),
    "validationFio": MessageLookupByLibrary.simpleMessage("Enter full name"),
    "validationName": MessageLookupByLibrary.simpleMessage("Enter first name"),
    "validationPasswordMin": MessageLookupByLibrary.simpleMessage(
      "at least 6 characters",
    ),
    "validationPasswordMismatch": MessageLookupByLibrary.simpleMessage(
      "passwords must match",
    ),
    "validationRequiredField": MessageLookupByLibrary.simpleMessage(
      "Field is filled incorrectly",
    ),
    "validationSurname": MessageLookupByLibrary.simpleMessage(
      "Enter last name",
    ),
    "webViewNoUrl": MessageLookupByLibrary.simpleMessage("No URL provided"),
  };
}
