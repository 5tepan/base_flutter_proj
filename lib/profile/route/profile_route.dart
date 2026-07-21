import 'package:base_flutter_proj/chat/chat_list_page.dart';
import 'package:base_flutter_proj/chat/chat_room_page.dart';
import 'package:base_flutter_proj/chat/config/chat_defaults.dart';
import 'package:base_flutter_proj/demo/calendar_demo_page.dart';
import 'package:base_flutter_proj/demo/dynamic_form_demo_page.dart';
import 'package:base_flutter_proj/demo/media_files_demo_page.dart';
import 'package:base_flutter_proj/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'profile_route.g.dart';

const String _profilePath = '/profile';
const String _mediaFilesDemoPath = 'media-demo';
const String _calendarDemoPath = 'calendar-demo';
const String _dynamicFormDemoPath = 'dynamic-form-demo';
const String _chatListPath = 'chats';
const String _chatDirectPath = 'chat';
const String _chatRoomPath = ':roomId';

@TypedGoRoute<ProfileRoute>(
  path: _profilePath,
  routes: [
    TypedGoRoute<MediaFilesDemoRoute>(path: _mediaFilesDemoPath),
    TypedGoRoute<CalendarDemoRoute>(path: _calendarDemoPath),
    TypedGoRoute<DynamicFormDemoRoute>(path: _dynamicFormDemoPath),
    TypedGoRoute<ChatDirectRoute>(path: _chatDirectPath),
    TypedGoRoute<ChatListRoute>(
      path: _chatListPath,
      routes: [
        TypedGoRoute<ChatRoomRoute>(path: _chatRoomPath),
      ],
    ),
  ],
)
class ProfileRoute extends GoRouteData with $ProfileRoute {
  const ProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ProfilePage();
  }
}

class MediaFilesDemoRoute extends GoRouteData with $MediaFilesDemoRoute {
  const MediaFilesDemoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MediaFilesDemoPage();
  }
}

class CalendarDemoRoute extends GoRouteData with $CalendarDemoRoute {
  const CalendarDemoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CalendarDemoPage();
  }
}

class DynamicFormDemoRoute extends GoRouteData with $DynamicFormDemoRoute {
  const DynamicFormDemoRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DynamicFormDemoPage();
  }
}

class ChatDirectRoute extends GoRouteData with $ChatDirectRoute {
  const ChatDirectRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatRoomPage(
      roomId: ChatDefaults.singleRoomId,
      title: ChatDefaults.singleRoomTitle,
    );
  }
}

class ChatListRoute extends GoRouteData with $ChatListRoute {
  const ChatListRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ChatListPage();
  }
}

class ChatRoomRoute extends GoRouteData with $ChatRoomRoute {
  const ChatRoomRoute({
    required this.roomId,
    this.title,
  });

  final String roomId;
  final String? title;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ChatRoomPage(roomId: roomId, title: title);
  }
}
