import 'package:base_flutter_proj/chat/api/chat_api.dart';
import 'package:base_flutter_proj/chat/api/chat_api_impl.dart';
import 'package:base_flutter_proj/chat/api/mock_chat_api.dart';
import 'package:base_flutter_proj/chat/repository/chat_repository.dart';
import 'package:base_flutter_proj/core/providers/api_providers.dart';
import 'package:base_flutter_proj/core/providers/core_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatApiProvider = Provider<ChatApi>((ref) {
  final config = ref.watch(configProvider);
  if (config.useMockChatApi) {
    return MockChatApi();
  }
  return ChatApiImpl(ref.watch(coreApiProvider));
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(ref.watch(chatApiProvider));
});
