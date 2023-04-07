class AppError {
  final String? _message;
  final Object? _error;
  final StackTrace? _stackTrace;

  Object? get error => _error;
  String? get message => _message;
  StackTrace? get stackTrace => _stackTrace;

  const AppError._(
    this._error,
    this._message,
    this._stackTrace,
  );

  factory AppError({
    required String message,
    required Object error,
    required StackTrace stackTrace,
  }) {
    return AppError._(
      error,
      message,
      stackTrace,
    );
  }

  @override
  String toString() => 'AppError{message: $_message, error: $_error, stackTrace: $_stackTrace}';
}
