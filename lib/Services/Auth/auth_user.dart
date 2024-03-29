import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

// The Auth User

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;
  final String? id;
  const AuthUser({
    required this.isEmailVerified,
    required this.email,
    this.id,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        isEmailVerified: user.emailVerified,
        email: user.email,
        id: user.uid,
      );
}
