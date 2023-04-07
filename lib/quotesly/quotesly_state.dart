import 'package:flutter/foundation.dart';

@immutable
abstract class QuoteslyMessage {
  String get message;
  MessageType get type;
}

enum MessageType { error, bookmark, success, none }

class QuoteslySuccessMessage implements QuoteslyMessage {
  @override
  final String message;
  @override
  final MessageType type;

  const QuoteslySuccessMessage(this.message, this.type);
}

class QuoteslyBookmarkMessage implements QuoteslyMessage {
  @override
  final String message;
  @override
  final MessageType type;

  const QuoteslyBookmarkMessage(this.message, this.type);
}

class QuoteslyErrorMessage implements QuoteslyMessage {
  final Object error;
  @override
  final String message;

  @override
  final MessageType type;

  const QuoteslyErrorMessage(this.message, this.error, this.type);

  @override
  String toString() => 'QuoteslyErrorMessage{message=$message, error=$error}';
}
