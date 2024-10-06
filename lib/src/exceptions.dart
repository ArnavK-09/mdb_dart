/// Exception thrown when a requested object cannot be found.
///
/// The [message] describes the error.
class ObjectNotFound implements Exception {
  final String message;
  ObjectNotFound([this.message = 'Object not found.']);

  @override
  String toString() => 'ObjectNotFound: $message';
}

/// Exception thrown when trying to create an object that already exists.
///
/// The [message] describes the error.
class ObjectAlreadyExists implements Exception {
  final String message;
  ObjectAlreadyExists([this.message = 'Object already exists']);

  @override
  String toString() => 'ObjectAlreadyExists: $message';
}

/// Exception thrown when an unsupported operation is attempted.
///
/// The [message] describes the error.
class ObjectNotSupported implements Exception {
  final String message;
  ObjectNotSupported([this.message = 'Object not supported.']);

  @override
  String toString() => 'ObjectNotSupported: $message';
}

/// Exception thrown when access is forbidden.
///
/// The [message] describes the error.
class Forbidden implements Exception {
  final String message;
  Forbidden([this.message = 'Access forbidden.']);

  @override
  String toString() => 'Forbidden: $message';
}

/// Exception thrown when access is unauthorized.
///
/// The [message] describes the error.
class Unauthorized implements Exception {
  final String message;
  Unauthorized([this.message = 'Unauthorized access.']);

  @override
  String toString() => 'Unauthorized: $message';
}

/// Exception thrown for unspecified errors.
///
/// The [message] describes the error.
class UnknownError implements Exception {
  final String message;
  UnknownError([this.message = 'An unknown error occurred.']);

  @override
  String toString() => 'UnknownError: $message';
}

/// Exception thrown when a value is invalid or out of range.
///
/// The [message] describes the error.
class ValueError implements Exception {
  final String message;

  ValueError(this.message);

  @override
  String toString() {
    return 'ValueError: $message';
  }
}
