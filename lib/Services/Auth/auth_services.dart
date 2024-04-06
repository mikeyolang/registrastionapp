import 'package:registrastionapp/Services/Auth/auth_provider.dart';
import 'package:registrastionapp/Services/Auth/auth_user.dart';

import 'firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  AuthService({required this.provider});

  factory AuthService.firebase() => AuthService(
        provider: FirebaseAuthProvider(),
      );
  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  Future<void> logOut() => provider.logOut();

  @override
  Future<void> sendEmailVerification() => provider.logOut();

  @override
  Future<void> initialize() async {
    await provider.initialize();
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      provider.sendPasswordReset(toEmail: toEmail);
}
