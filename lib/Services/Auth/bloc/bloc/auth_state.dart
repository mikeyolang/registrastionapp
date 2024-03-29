import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import '../../auth_user.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class AuthStateLogIn extends AuthState {
  final AuthUser user;
  const AuthStateLogIn(this.user);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification();
}

// class AuthStateLoggedOut extends AuthState {
//   final Exception? exception;
//   final bool isLoading;
//   const AuthStateLoggedOut(this.exception, this.isLoading);
// }
class AuthStateRegistering extends AuthState {
  final Exception? exception;

  const AuthStateRegistering({required this.exception});
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized();
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;
  const AuthStateLoggedOut({
    required this.exception,
    required this.isLoading,
  });

  @override
  List<Object?> get props => [exception, isLoading];
}
