extension IsEmptyOrNullExt on String? {
  bool get isEmptyOrNull => this == null || this!.isEmpty;
}
