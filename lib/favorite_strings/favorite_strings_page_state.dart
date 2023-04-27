import 'package:flutter/foundation.dart';

@immutable
abstract class FavoriteStringsMessage {
  String get message;
  MessageType get type;
}

enum MessageType { error, bookmark, success, none }

class FavoriteStringsSuccessMessage implements FavoriteStringsMessage {
  @override
  final String message;
  @override
  final MessageType type;

  const FavoriteStringsSuccessMessage(this.message, this.type);
}

class FavoriteStringsBookmarkMessage implements FavoriteStringsMessage {
  @override
  final String message;
  @override
  final MessageType type;

  const FavoriteStringsBookmarkMessage(this.message, this.type);
}

class FavoriteStringsErrorMessage implements FavoriteStringsMessage {
  final Object error;
  @override
  final String message;

  @override
  final MessageType type;

  const FavoriteStringsErrorMessage(this.message, this.error, this.type);

  @override
  String toString() => 'FavoriteStringsErrorMessage{message=$message, error=$error}';
}
