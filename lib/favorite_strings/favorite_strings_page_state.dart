import 'package:flutter/foundation.dart';

import 'models/models.dart';

@immutable
abstract class FavoriteStringsMessage {
  String get message;
  MessageType get type;
}

enum MessageType { error, favorite, success, none }

class FavoriteStringsSuccessMessage implements FavoriteStringsMessage {
  @override
  final String message;
  @override
  final MessageType type;

  const FavoriteStringsSuccessMessage(this.message, this.type);
}

class FavoriteStringsFavoriteMessage implements FavoriteStringsMessage {
  @override
  final String message;
  @override
  final MessageType type;

  final FavoriteString favoriteString;

  const FavoriteStringsFavoriteMessage(this.message, this.type, this.favoriteString);
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
