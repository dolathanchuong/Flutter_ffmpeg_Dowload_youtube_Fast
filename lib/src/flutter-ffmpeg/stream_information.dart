class StreamInformation {
  final Map<dynamic, dynamic> _allProperties;

  /// Creates a new [StreamInformation] instance
  StreamInformation(this._allProperties);

  /// Returns all properties in a map or null if no properties are found
  Map<dynamic, dynamic> getAllProperties() {
    return _allProperties;
  }
}
