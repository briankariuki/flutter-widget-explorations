import 'package:flutter/foundation.dart';

@immutable
abstract class QuoteslyMessage {}

enum MessageType { error, bookmark, success, none }

class QuoteslySuccessMessage implements QuoteslyMessage {
  final String message;
  final MessageType type;

  const QuoteslySuccessMessage(this.message, this.type);
}

class QuoteslyBookmarkMessage implements QuoteslyMessage {
  final String message;
  final MessageType type;

  const QuoteslyBookmarkMessage(this.message, this.type);
}

class QuoteslyErrorMessage implements QuoteslyMessage {
  final Object error;
  final String message;

  const QuoteslyErrorMessage(this.message, this.error);

  @override
  String toString() => 'QuoteslyErrorMessage{message=$message, error=$error}';
}
