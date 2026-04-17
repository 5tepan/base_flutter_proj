import 'package:base_flutter_proj/auth/auth_by_phone_form_page.dart';
import 'package:base_flutter_proj/auth/phone_confirmation_form_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'auth_route.g.dart';

const String _authPath = '/auth';
const String _writePhonePath = 'phone';
const String _confirmPhonePath = 'confirm/:phoneNumber';

@TypedGoRoute<AuthRoute>(
  path: _authPath,
  routes: [
    TypedGoRoute<AuthByPhoneFormRoute>(path: _writePhonePath),
    TypedGoRoute<PhoneConfirmationFormRoute>(path: _confirmPhonePath),
  ],
)
class AuthRoute extends GoRouteData with $AuthRoute {
  const AuthRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthByPhoneFormPage();
  }
}

class AuthByPhoneFormRoute extends GoRouteData with $AuthByPhoneFormRoute {
  const AuthByPhoneFormRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AuthByPhoneFormPage();
  }
}

class PhoneConfirmationFormRoute extends GoRouteData
    with $PhoneConfirmationFormRoute {
  const PhoneConfirmationFormRoute({required this.phoneNumber});

  final String phoneNumber;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PhoneConfirmationFormPage(phoneNumber: phoneNumber);
  }
}
