import 'package:base_flutter_proj/core/base/base_auth/entities/auth_session.dart';

/// Результат одной попытки обновить access token.
sealed class TokenRefreshResult {
  const TokenRefreshResult();
}

/// Сервер выдал новую сессию, она уже записана в storage и token holder.
final class TokenRefreshSuccess extends TokenRefreshResult {
  const TokenRefreshSuccess(this.session);

  final AuthSession session;
}

/// Refresh-токен отклонён. Сессия очищена.
final class TokenRefreshRejected extends TokenRefreshResult {
  const TokenRefreshRejected();
}

/// Сеть или неожиданный сбой. Сохранённая сессия не трогается.
final class TokenRefreshUnavailable extends TokenRefreshResult {
  const TokenRefreshUnavailable();
}
