class ObjectNotFound implements Exception {
  final String message;
  ObjectNotFound([this.message = 'Object not found.']);

  @override
  String toString() => 'ObjectNotFound: $message';
}

class ObjectAlreadyExists implements Exception {
  final String message;
  ObjectAlreadyExists([this.message = 'Object already exists']);

  @override
  String toString() => 'ObjectAlreadyExists: $message';
}

class ObjectNotSupported implements Exception {
  final String message;
  ObjectNotSupported([this.message = 'Object not supported.']);

  @override
  String toString() => 'ObjectNotSupported: $message';
}

class Forbidden implements Exception {
  final String message;
  Forbidden([this.message = 'Access forbidden.']);

  @override
  String toString() => 'Forbidden: $message';
}

class Unauthorized implements Exception {
  final String message;
  Unauthorized([this.message = 'Unauthorized access.']);

  @override
  String toString() => 'Unauthorized: $message';
}

class UnknownError implements Exception {
  final String message;
  UnknownError([this.message = 'An unknown error occurred.']);

  @override
  String toString() => 'UnknownError: $message';
}

class ValueError implements Exception {
  final String message;

  ValueError(this.message);

  @override
  String toString() {
    return 'ValueError: $message';
  }
}
