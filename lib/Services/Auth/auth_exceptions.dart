// Log in Exceptions

class UserNotFoundException implements Exception {}

class WrongPasswordException implements Exception {}

// Register Exceptions

class WeakPasswordException implements Exception {}

class EmailAlreadyInUseException implements Exception {}

class InvalidEmailException implements Exception {}

// Generic Exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
