import 'dart:convert';

import 'package:base_flutter_proj/auth/model/auth_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthSessionStorage {
  static const _sessionKey = 'auth_session';

  const AuthSessionStorage(this._storage);

  final FlutterSecureStorage _storage;

  Future<AuthSession?> read() async {
    final raw = await _storage.read(key: _sessionKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AuthSession.fromJson(json);
  }

  Future<void> save(AuthSession session) async {
    await _storage.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<void> clear() async {
    await _storage.delete(key: _sessionKey);
  }
}
