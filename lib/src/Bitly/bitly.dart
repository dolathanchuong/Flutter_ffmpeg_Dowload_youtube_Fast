import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../Bitly/constant.dart';
import '../Bitly/flutter_url_shortener.dart';

///
/// Singleton
///
class FShortBitly {
  FShortBitly._internal();

  static FShortBitly? _instance;

  static FShortBitly get instance => _instance ??= FShortBitly._internal();

  static String? _token;

  /// Initital when open app or before generate shorten link
  ///
  /// @param [token] access token to connecting to [Bitly](https://dev.bitly.com/)
  ///
  void setup({required String token}) {
    _token ??= token;
  }

  /// Generate shorten URL
  ///
  /// @param [longUrl] url that you want to generate shorten
  ///
  /// Example
  /// ```
  /// try {
  ///       FShort.instance
  ///           .generateShortenURL(longUrl: 'https://www.google.com.vn/')
  ///           .then((value) {
  ///         setState(() {
  ///           _shortenURL = value.link;
  ///         });
  ///       });
  ///     } on BitlyException catch (_) {
  ///
  ///     } on Exception catch (_) {
  ///
  ///     }
  /// ```
  ///
  Future<BitlyModel> generateShortenURL({
    required String longUrl,
    String? groupId,
    String? domain = 'bit.ly',
  }) async {
    final client = HttpClient();
    final endPoint = Uri.https('api-ssl.bitly.com', '/v4/shorten');

    final response = await client.postUrl(endPoint).then((request) {
      request.headers
        ..set(HttpHeaders.contentTypeHeader, 'application/json')
        ..set(HttpHeaders.authorizationHeader, 'Bearer $_token');

      final body = {
        'long_url': longUrl,
        'domain': domain,
        'group_guid': groupId,
      };
      request.add(utf8.encode(json.encode(body)));
      return request.close();
    });

    final responseBody = await response.transform(utf8.decoder).join();

    if (response.statusCode == StatusCode.sUCCESS ||
        response.statusCode == StatusCode.cREATED) {
      return BitlyModel.fromJson(json.decode(responseBody));
    } else {
      throw BitlyException.fromJson(json.decode(responseBody));
    }
  }

  Future<http.Response> deleteShortenURL({
    required String id,
    String? groupId,
    String? domain = 'bit.ly',
  }) async {
    const String token = '03ffe1613d38a4d40e85aeed6ba535aedce6c228';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $token',
    };

    final http.Response response = await http.delete(
      Uri.parse('https://api-ssl.bitly.com/v4/bitlinks/$id'),
      headers: headers,
    );

    if (response.statusCode == StatusCode.sUCCESS ||
        response.statusCode == StatusCode.cREATED) {
      return response;
    } else {
      throw response;
    }
  }

  ///
  /// Converts a long url to a Bitlink and sets additional parameters.
  /// ```
  /// try {
  ///       FShort.instance
  ///           .createBitLink(
  ///               params: BitlyParams(
  ///         longUrl: "https://dev.bitly.com",
  ///         domain: 'bit.ly',
  ///         tags: ['ver1.1', 'ver1.2'],
  ///         deeplinks: [
  ///           DeeplinkParams(
  ///             appId: 'com.hades.test',
  ///             appUriPath: '/store?id=123456',
  ///             installUrl:
  ///                 'https://play.google.com/store/apps/details?id=com.hades.test&hl=en_US',
  ///             installType: 'promote_install',
  ///           ),
  ///         ],
  ///       ))
  ///           .then((value) {
  ///         setState(() {
  ///           _customURL = value.link;
  ///         });
  ///       });
  ///     } on BitlyException catch (_) {
  ///       //
  ///     } on Exception catch (_) {
  ///       //
  ///     }
  /// ```
  ///
  Future<BitlyModel> createBitLink({required BitlyParams params}) async {
    final client = HttpClient();
    final endPoint = Uri.https('api-ssl.bitly.com', '/v4/bitlinks');

    final response = await client.postUrl(endPoint).then((request) {
      request.headers
        ..set(HttpHeaders.contentTypeHeader, 'application/json')
        ..set(HttpHeaders.authorizationHeader, 'Bearer $_token');

      request.add(utf8.encode(json.encode(params.toJson())));
      return request.close();
    });

    final responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode == StatusCode.sUCCESS ||
        response.statusCode == StatusCode.cREATED) {
      return BitlyModel.fromJson(json.decode(responseBody));
    } else {
      throw BitlyException.fromJson(json.decode(responseBody));
    }
  }
}
