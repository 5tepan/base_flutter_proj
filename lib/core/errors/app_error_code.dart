/// Коды ошибок data/API-слоя. Текст для пользователя — в [ErrorLocalizer].
enum AppErrorCode {
  // Network / HTTP
  noInternet,
  connectionError,
  unknownError,
  requestFailed,

  // Parsing
  dataNotFound,
  parseError,
  missingMeta,
  missingData,
  invalidMeta,
  badRequestFormat,
  invalidJson,

  // Auth
  phoneRequired,
  invalidConfirmationCode,
  sessionExpired,
  sendCodeFailed,
  verifyCodeFailed,
  resendCodeFailed,
  refreshSessionFailed,

  // Validation
  dateOfBirthRequired,
  nameRequired,
  surnameRequired,
  fioRequired,
  fieldRequired,
  phoneInvalid,
  codeRequired,
  passwordMinLength,
  emailRequired,
  emailInvalid,
  passwordMismatch,

  // Chat
  sendMessageFailed,
}
