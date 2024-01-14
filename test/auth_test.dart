import 'package:registrastionapp/Services/Auth/auth_exceptions.dart';
import 'package:registrastionapp/Services/Auth/auth_provider.dart';
import 'package:registrastionapp/Services/Auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group("Mock Authentication", () {
    final provider = MockAuthProvider();
    // Testing Initialization
    test("should not be Initialized to begin with", () {
      expect(provider.isInitialized, false);
    });
    // Testing the logging before initialization
    test("Cannot Log in before initilization", () {
      expect(
        provider.logOut(),
        throwsA(
          const TypeMatcher<NotInitializedException>(),
        ),
      );
    });
    test("Should be able to be initilialized", () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });
    test("User Should be null after initialization", () {
      expect(provider.currentUser, null);
    });
    test(
      "Should be able to be initilailized withing 2 Seconds",
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );
    test("Should create user should delegate log in function", () async {
      final badEmailUser = provider.createUser(
        email: "michael@gmail.com",
        password: "mikeyolang",
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundException>()),
      );
      final badPasswordUser = provider.createUser(
        email: "someone@gmail.com",
        password: "mikeyolang",
      );
      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<WrongPasswordException>()),
      );
      final user = await provider.createUser(
        email: "foo",
        password: "bar",
      );
      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });
    test("Logged in user should be able to get Verified", () {
      provider.sendEmailVerification();
      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });
    test("Should be able to log in and log out again", () async {
      await provider.logOut();
      await provider.logIn(
        email: "email",
        password: "password",
      );
      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == "michael@gmail.com") throw UserNotFoundException();
    if (password == "mikeyolang") throw WrongPasswordException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;
  }
}
