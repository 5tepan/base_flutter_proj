import 'package:base_flutter_proj/demo/calendar_demo_page.dart';
import 'package:base_flutter_proj/demo/media_files_demo_page.dart';
import 'package:base_flutter_proj/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'profile_route.g.dart';

const String _profilePath = '/profile';
const String _mediaFilesDemoPath = 'media-demo';
const String _calendarDemoPath = 'calendar-demo';

@TypedGoRoute<ProfileRoute>(
  path: _profilePath,
  routes: [
    TypedGoRoute<MediaFilesDemoRoute>(path: _mediaFilesDemoPath),
    TypedGoRoute<CalendarDemoRoute>(path: _calendarDemoPath),
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
