import 'package:youtubedart/src/flutter-ffmpeg/stream_information.dart';

class MediaInformation {
  final Map<dynamic, dynamic>? _allProperties;

  /// Creates a new [MediaInformation] instance
  MediaInformation(this._allProperties);

  /// Returns all streams
  List<StreamInformation>? getStreams() {
    List<StreamInformation> list =
        List<StreamInformation>.empty(growable: true);
    dynamic streamList;

    if (_allProperties == null) {
      streamList = List.empty(growable: true);
    } else {
      streamList = _allProperties!["streams"];
    }

    if (streamList != null) {
      streamList.forEach((element) {
        list.add(StreamInformation(element));
      });
    }

    return list;
  }

  /// Returns all media properties in a map or null if no media properties are found
  Map<dynamic, dynamic>? getMediaProperties() {
    if (_allProperties == null) {
      return Map();
    } else {
      return _allProperties!["format"];
    }
  }

  /// Returns all properties in a map or null if no properties are found
  Map<dynamic, dynamic> getAllProperties() {
    return _allProperties!;
  }
}
