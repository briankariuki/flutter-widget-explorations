extension ParseToString on Enum {
  String toShortString() {
    return toString().split('.').last;
  }
}
