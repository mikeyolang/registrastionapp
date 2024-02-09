import 'package:registrastionapp/Services/Auth/auth_user.dart';

abstract class AuthProvider {
  AuthUser? get currentUser;
  Future<void> initialize();
  // Function that logs in the user
  Future<AuthUser> logIn({
    required String email,
    required String password, 
  });

  // Function than can create a User
  Future<AuthUser> createUser({
    required String email,
    required String password,
  });
  // For Logging Out
  Future<void> logOut();

  // For sending a Email Verification
  Future<void> sendEmailVerification();
}
