extension NotPositiveOrNullNumExt on int? {
  bool get isEmptyOrNull => this == null || this! < 1;
}
