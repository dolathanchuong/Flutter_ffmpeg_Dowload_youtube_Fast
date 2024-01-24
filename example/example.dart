// ignore_for_file: avoid_print
import 'package:youtubedart/youtube_explode_dart.dart';

Future<void> main() async {
  final yt = YoutubeExplode();
  //final streamInfo = await yt.videos.streamsClient.getManifest('fRh_vgS2dFE');
  //print(streamInfo);
  // Chanel About
  final channel = await yt.channels.get369('UC56D-IHcUvLVFTX_8NpQMXg');
  print(
      "\n channelLink: ${channel.url} \n channel subscribersCount: ${channel.subscribersCount} \n channel videos Count: ${channel.videosCount}");
  final videoDetail = await yt.videos.get('7t0SqerlBA0');
  print(
      '|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
  print(videoDetail.watchPage!.playerResponse!.videoTitle);
  print(
      '|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||');
  final videoD = await yt.videos.get('Wgvql9ui1-U');
  print('videoLikeCount : ${videoD.watchPage!.videoLikeCount}');
  // Close the YoutubeExplode's http client.
  yt.close();
}
