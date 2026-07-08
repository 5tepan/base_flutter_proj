import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatTypingState {
  const ChatTypingState({this.typingUsers = const {}});

  /// userId → отображаемое имя.
  final Map<String, String> typingUsers;

  bool get isAnyoneTyping => typingUsers.isNotEmpty;

  Set<String> get typingUserNames => typingUsers.values.toSet();
}

class ChatTypingNotifier extends Notifier<ChatTypingState> {
  ChatTypingNotifier(this.roomId);

  final String roomId;

  @override
  ChatTypingState build() => const ChatTypingState();

  void setTyping({
    required String userId,
    required String? userName,
    required bool isTyping,
  }) {
    if (userId == 'me') {
      return;
    }

    final users = Map<String, String>.from(state.typingUsers);

    if (isTyping) {
      final label = (userName?.trim().isNotEmpty ?? false)
          ? userName!.trim()
          : userId;
      users[userId] = label;
    } else {
      users.remove(userId);
    }

    state = ChatTypingState(typingUsers: users);
  }

  void clear() {
    state = const ChatTypingState();
  }
}

final chatTypingProvider = NotifierProvider.family.autoDispose<
    ChatTypingNotifier,
    ChatTypingState,
    String>(
  ChatTypingNotifier.new,
);
