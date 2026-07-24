sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.message);
  final String message;
}

/// Para providers `Future<T>` de Riverpod, que necesitan lanzar (no devolver
/// un `Result`) para que `AsyncValue.error` lo capture.
extension ResultUnwrap<T> on Result<T> {
  T getOrThrow() => switch (this) {
    Success(:final value) => value,
    Failure(:final message) => throw ResultException(message),
  };
}

class ResultException implements Exception {
  ResultException(this.message);
  final String message;

  @override
  String toString() => message;
}
