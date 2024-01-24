//TODO: Fixing the console printing.
import 'dart:async';
import 'dart:io';
import 'package:console/console.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';
//import 'package:youtubedart/src/Bitly/bitly.dart';
//import 'package:youtubedart/src/flutter-ffmpeg/flutter_ffmpeg.dart';
import 'package:youtubedart/youtube_explode_dart.dart';

import '../test/search_test.dart';

// Initialize the YoutubeExplode instance.
final yt = YoutubeExplode();
//final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
Future<void> main() async {
  stdout.writeln('Type the video id or url: ');

  final url = stdin.readLineSync()!.trim();

  // Save the video to the download directory.
  Directory('downloads').createSync();

  // Download the video.
  await download(url);
  // await getalltype(url);
  // await forfutureListoVideos('PL2NGoQ3h2pGrggYkZIkZGbXdPC8R4AX1n');
  // await forfutureListoInfo('PL2NGoQ3h2pGrggYkZIkZGbXdPC8R4AX1n');
  // await forfutureSearchVideos('mV-Ctfi2AEk');
  // await getAudiosize('4ho6AKpkB4U');
  // await getAudio('4ho6AKpkB4U');
  //await getFullVideoNonMutedsize('4ho6AKpkB4U'); //==>369
  // await getFullVideoNonMuted('4ho6AKpkB4U');
  // await getVideosize('4ho6AKpkB4U');
  // await getVideo('4ho6AKpkB4U');

  // await margeBoth(await getFileName('4ho6AKpkB4U'),
  //     await getLastVideo('4ho6AKpkB4U'), await getLastAudio('4ho6AKpkB4U'));

  // await getVideoOnlysize('4ho6AKpkB4U');

  // var pp = await urlShortener('').whenComplete(() => prints(letters));
  // stdout.writeln(pp);

  // await deleteShortener('bit.ly/3sWoyl3').whenComplete(() => prints(letters));

  // var pp =
  //     await delShortener('bit.ly/3R1lLPw').whenComplete(() => prints(letters));
  // stdout.writeln(pp);

  //stdout.writeln(await getLastAudio('Ay9N8n_mlAs')); //OLnX0OUhR5Q
  //stdout.writeln(await getLastVideo('OLnX0OUhR5Q'));
  yt.close();
  exit(0);
}

Future<void> getalltype(String id) async {
  // Get video metadata.
  final video = await yt.videos.get(id);
  stdout.writeln(video.url);
  stdout.writeln('>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<');
  // Get the video manifest.
  final manifest = await yt.videos.streamsClient.getManifest(id);

  var listType = manifest.muxed;
  // Get the audio track with the highest bitrate.
  final audio = listType.last; //.first;
  final audioStream = yt.videos.streamsClient.get(audio);

  // Compose the file name removing the unallowed characters in windows.
  final fileName = '${video.title}.${audio.container.name}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
  final file = File('downloads/$fileName');

  // Delete the file if exists.
  if (file.existsSync()) {
    file.deleteSync();
  }

  // Open the file in writeAppend.
  final output = file.openWrite(mode: FileMode.writeOnlyAppend);

  // Track the file download status.
  final len = audio.size.totalBytes;
  var count = 0;

  // Create the message and set the cursor position.
  final msg = 'Downloading ${video.title}.${audio.container.name}';
  stdout.writeln(msg);

  // Listen for data received.
  final progressBar = ProgressBar();
  await for (final data in audioStream) {
    // Keep track of the current downloaded data.
    count += data.length;

    // Calculate the current progress.
    final progress = ((count / len) * 100).ceil();

    // Update the progressbar.
    progressBar.update(progress);

    // Write to file.
    output.add(data);
  }
  await output.close();
}

Future<void> download(String id) async {
  // Get video metadata.
  final video = await yt.videos.get(id);

  // Get the video manifest.
  final manifest = await yt.videos.streamsClient.getManifest(id);
  final streams = manifest.audioOnly.withHighestBitrate();

  // Get the audio track with the highest bitrate.
  final audio = streams; //.first;
  final audioStream = yt.videos.streamsClient.get(audio);

  // Compose the file name removing the unallowed characters in windows.
  final fileName = '${video.title}.${audio.container.name}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
  final file = File('downloads/$fileName');

  // Delete the file if exists.
  if (file.existsSync()) {
    file.deleteSync();
  }

  // Open the file in writeAppend.
  final output = file.openWrite(mode: FileMode.writeOnlyAppend);

  // Track the file download status.
  final len = audio.size.totalBytes;
  var count = 0;

  // Create the message and set the cursor position.
  final msg = 'Downloading ${video.title}.${audio.container.name}';
  stdout.writeln(msg);

  // Listen for data received.
  final progressBar = ProgressBar();
  await for (final data in audioStream) {
    // Keep track of the current downloaded data.
    count += data.length;

    // Calculate the current progress.
    final progress = ((count / len) * 100).ceil();

    // Update the progressbar.
    progressBar.update(progress);

    // Write to file.
    output.add(data);
  }
  await output.close();
}

Future<void> forfutureListoVideos(String listid) async {
  await yt.playlists.get(listid).then((Playlist value) async {
    stdout.writeln(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>_Link in List_<<<<<<<<<<<<<<<<<<<<<<<<');
    await for (final Video video in yt.playlists.getVideos(value.id)) {
      stdout.writeln(video.url);
    }
    stdout.writeln(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>_Link in List END_<<<<<<<<<<<<<<<<<<<<<<<<');
  });
}

Future<void> forfutureSearchVideos(String keyworld) async {
  yt.channels.getByVideo(keyworld).then((Channel value) {
    stdout.writeln(value);
  });
}

Future<void> forfutureListoInfo(String listid) async {
  late Playlist p;
  await yt.playlists.get(listid).then((Playlist value) {
    p = value;
  });
  stdout.writeln(p);
}

/// get all audioOnly
Future<void> getAudiosize(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final AudioStreamInfo i in manifest.audioOnly) {
    final List<String> sp = i.size.toString().split('.');
    // final String _f = _sp[0];
    // final String _l = _sp[1].substring(0, 2);
    // final String _ext = _sp[1].substring(_sp[1].length - 2);
    stdout.writeln(sp);
  }
}

Future<void> getAudio(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final AudioStreamInfo i in manifest.audioOnly) {
    final sp = i.url.toString();
    stdout.writeln("$sp@");
  }
}

/// get full Videos
Future<void> getFullVideoNonMutedsize(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final VideoStreamInfo i in manifest.muxed) {
    // final List<String> sp = i.size.toString().split('.');
    // final String f = sp[0];
    // final String l = sp[1].substring(0, 2);
    // final String ext = sp[1].substring(sp[1].length - 2);
    final sp = i.size.toString();
    final vcode = i.codec.toString().split(';')[0].split('/')[1];
    final videoQuality = i.videoQuality.toString().split('.')[1];
    final urlroot = await urlShortener(i.url.toString())
        .whenComplete(() => prints(letters));
    stdout.writeln("$sp(-_-)$vcode(-_-)$videoQuality(-_-)$urlroot");
  }
}

Future<void> getFullVideoNonMuted(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final VideoStreamInfo i in manifest.muxed) {
    final sp = i.url.toString();
    stdout.writeln("$sp@");
  }
}

/// get Videos
Future<void> getVideosize(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final VideoStreamInfo i in manifest.video) {
    // final List<String> sp = i.size.toString().split('.');
    // final String f = sp[0];
    // final String l = sp[1].substring(0, 2);
    // final String ext = sp[1].substring(sp[1].length - 2);
    final sp = i.size.toString();
    final vcode = i.codec.toString().split(';')[0].split('/')[1];
    final videoQuality = i.videoQuality.toString().split('.')[1];
    final urlroot = await urlShortener(i.url.toString())
        .whenComplete(() => prints(letters));
    stdout.writeln("$sp(-_-)$vcode(-_-)$videoQuality(-_-)$urlroot");
  }
}

Future<void> getVideo(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final VideoStreamInfo i in manifest.video) {
    final sp = i.url.toString();
    stdout.writeln("$sp@");
  }
}

/// get VideoOnly
Future<void> getVideoOnlysize(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final VideoStreamInfo i in manifest.videoOnly) {
    final List<String> sp = i.size.toString().split('.');
    // final String f = sp0[0];
    // final String l = sp0[1].substring(0, 2);
    // final String ext = sp0[1].substring(sp0[1].length - 2);
    stdout.writeln("$sp@");
  }
}

Future<void> getVideoOnly(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  for (final VideoStreamInfo i in manifest.videoOnly) {
    final sp = i.url.toString();
    stdout.writeln("$sp@");
  }
}

/// region
Future<String> getFileName(String id) async {
  final video = await yt.videos.get(id);
  final manifest = await yt.videos.streamsClient.getManifest(id);

  var listType = manifest.muxed;
  // Get the audio track with the highest bitrate.
  final audio = listType.last; //.first;
  final fileName = '${video.title}.${audio.container.name}'
      .replaceAll(r'\', '')
      .replaceAll('/', '')
      .replaceAll('*', '')
      .replaceAll('?', '')
      .replaceAll('"', '')
      .replaceAll('<', '')
      .replaceAll('>', '')
      .replaceAll('|', '');
  // stdout.writeln(fileName);
  return fileName;
}

Future<String> getLastAudio(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  return manifest.audioOnly.last.url.toString();
}

Future<String> getLastVideo(String id) async {
  final YoutubeExplode yt = YoutubeExplode();
  final StreamManifest manifest = await yt.videos.streamsClient.getManifest(id);
  return manifest.videoOnly.bestQuality.url.toString();
}

/*
Future<void> margeBoth(
  String name,
  String video,
  String audio,
) async {
  stdout.writeln(12);

  stdout.writeln(34);
  flutterFFmpeg.execute('-i $video -i $audio -c copy $name.mp4').then((int d) {
    stdout.writeln('Return code $d');
  });
}
*/
/// endregion
Future<String?> urlShortener(String url) async {
  FShortBitly.instance.setup(token: '03ffe1613d38a4d40e85aeed6ba535aedce6c228');
  //const url = 'https://www.youtube.com/watch?v=GDZk2_SvsM0';
  try {
    final response = await FShortBitly.instance.generateShortenURL(
      longUrl: url,
    );
    stdout.writeln(response.title);
    return response.link;
  } catch (e) {
    stdout.writeln('Error shortening URL: $e');
    return null;
  }
}

Future<String?> delShortener(String url) async {
  try {
    final response = await FShortBitly.instance.deleteShortenURL(
      id: url,
    );

    return response.body;
  } catch (e) {
    stdout.writeln('Error shortening URL: $e');
    return null;
  }
}

Future<void> deleteShortener(String url) async {
  const String token = '03ffe1613d38a4d40e85aeed6ba535aedce6c228';

  final Map<String, String> headers = {
    'Authorization': 'Bearer $token',
  };

  final http.Response response = await http.delete(
    Uri.parse('https://api-ssl.bitly.com/v4/bitlinks/$url'),
    headers: headers,
  );

  stdout.writeln('Response status: ${response.statusCode}');
  stdout.writeln('Response body: ${response.body}');
}
