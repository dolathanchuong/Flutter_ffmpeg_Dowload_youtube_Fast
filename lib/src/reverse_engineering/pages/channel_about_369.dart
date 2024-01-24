import 'package:html/parser.dart' as parser;

import '../../exceptions/exceptions.dart';
import '../../extensions/helpers_extension.dart';
import '../../retry.dart';
import '../models/initial_data.dart';
import '../models/youtube_page.dart';
import '../youtube_http_client.dart';

///
class ChannelPageAbout extends YoutubePage<_InitialData> {
  ///
  bool get isOk => root!.querySelector('meta[property="og:url"]') != null;

  ///
  String get channelUrl =>
      root!.querySelector('meta[property="og:url"]')?.attributes['content'] ??
      '';

  ///
  String get channelId => channelUrl.substringAfter('channel/');

  ///
  String get channelDescription =>
      root!
          .querySelector('meta[property="og:description"]')
          ?.attributes['content'] ??
      '';

  ///
  String get channelLogoUrl =>
      root!.querySelector('meta[property="og:image"]')?.attributes['content'] ??
      '';

  String get channelBannerUrl => initialData.bannerUrl ?? '';

  int? get videosCount => initialData.videosCount;

  String? get subscribersCount => initialData.subscribersCount;

  ///
  ChannelPageAbout.parse(String raw)
      : super(parser.parse(raw), (root) => _InitialData(root));

  ///
  static Future<ChannelPageAbout> get(YoutubeHttpClient httpClient, String id) {
    final url = 'https://www.youtube.com/channel/$id?hl=en';

    return retry(httpClient, () async {
      final raw = await httpClient.getString(url);
      final result = ChannelPageAbout.parse(raw);

      if (!result.isOk) {
        throw TransientFailureException('Channel page is broken');
      }
      return result;
    });
  }

  ///
  static Future<ChannelPageAbout> getByUsername(
    YoutubeHttpClient httpClient,
    String username,
  ) {
    var url = 'https://www.youtube.com/user/$username?hl=en';

    return retry(httpClient, () async {
      try {
        final raw = await httpClient.getString(url);
        final result = ChannelPageAbout.parse(raw);

        if (!result.isOk) {
          throw TransientFailureException('Channel page is broken');
        }
        return result;
      } on FatalFailureException catch (e) {
        if (e.statusCode != 404) {
          rethrow;
        }
        url = 'https://www.youtube.com/c/$username?hl=en';
      }
      throw FatalFailureException('', 0);
    });
  }

  ///
  static Future<ChannelPageAbout> getByHandle(
    YoutubeHttpClient httpClient,
    String handle,
  ) {
    final url = 'https://www.youtube.com/$handle?hl=en';

    return retry(httpClient, () async {
      try {
        final raw = await httpClient.getString(url);
        final result = ChannelPageAbout.parse(raw);

        if (!result.isOk) {
          throw TransientFailureException('Channel page is broken');
        }
        return result;
      } on FatalFailureException catch (e) {
        if (e.statusCode != 404) {
          rethrow;
        }
      }
      throw FatalFailureException('', 0);
    });
  }
}

class _InitialData extends InitialData {
  static final RegExp _subCountExp = RegExp(r'(\d+(?:\.\d+)?)(K|M|\s)');

  _InitialData(super.root);

  String? get subscribersCount => root
      .get('header')
      ?.get('c4TabbedHeaderRenderer')
      ?.get('subscriberCountText')
      ?.get('accessibility')
      ?.get('accessibilityData')
      ?.getT<String>('label');

  int? get videosCount {
    final renderer = root.get('header')?.get('c4TabbedHeaderRenderer');
    //print(renderer1);
    //print(renderer?['videosCountText']['runs'][0]);
    // print(renderer
    //     ?.get('videosCountText')
    //     ?.getList('runs')
    //     ?.first
    //     .getT<String>('text'));
    if (renderer?['videosCountText'] == null) {
      return null;
    }
    final runs = renderer?['videosCountText']['runs'];
    final numericTextList = runs
        .map((run) => run?['text'] as String?)
        .where((text) => text != null)
        .toList();
    // print(numericTextList);
    final subText = numericTextList.join();
    if (subText == null) {
      return null;
    }
    final match = _subCountExp.firstMatch(subText); // Get index 0
    // print(numericTextList[1]);
    if (match == null) {
      return null;
    }
    if (match.groupCount != 2) {
      return null;
    }

    final count = double.tryParse(match.group(1) ?? '');
    if (count == null) {
      return null;
    }

    final multiplierText = match.group(2);
    if (multiplierText == null) {
      return null;
    }

    var multiplier = 1;
    if (multiplierText == 'K') {
      multiplier = 1000;
    } else if (multiplierText == 'M') {
      multiplier = 1000000;
    }

    return (count * multiplier).toInt();
  }

  //endpoint
  String? get popup {
    final renderer = root.get('header')?.get('c4TabbedHeaderRenderer');
    if (renderer?['tagline'] == null) {
      return null;
    }
    final runs = renderer?['tagline'];

    return (runs).toString();
  }

  String? get bannerUrl => root
      .get('header')
      ?.get('c4TabbedHeaderRenderer')
      ?.get('banner')
      ?.getList('thumbnails')
      ?.first
      .getT<String>('url');
}
