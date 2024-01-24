import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:youtubedart/youtube_explode_dart.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VideoDownload Demo by DoLaThanChuong',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'DoLaThanChuong Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Insert the video id or url',
            ),
            TextField(controller: textController),
            ElevatedButton(
              child: const Text('Download'),
              onPressed: () async {
                // Here you should validate the given input or else an error
                // will be thrown.
                final yt = YoutubeExplode();
                final id = VideoId(textController.text.trim());
                final video = await yt.videos.get(id);

                //Get audio|video
                final StreamManifest manifestroot =
                    await yt.videos.streamsClient.getManifest(id);
                // final audioroot = manifestroot.audioOnly.first.url.toString();
                // final videoroot =
                //     manifestroot.videoOnly.bestQuality.url.toString();
                //Bitly Short
                // FShortBitly.instance
                //     .setup(token: '03ffe1613d38a4d40e85aeed6ba535aedce6c228');
                // final stResponseAudio =
                //     await FShortBitly.instance.generateShortenURL(
                //   longUrl: audioroot,
                // );
                // final stResponseVideo =
                //     await FShortBitly.instance.generateShortenURL(
                //   longUrl: videoroot,
                // );
                // Get name video
                final audiof = manifestroot.muxed.last;
                final fileName = '${video.title}.${audiof.container.name}'
                    .replaceAll(r'\', '')
                    .replaceAll('/', '')
                    .replaceAll('*', '')
                    .replaceAll('?', '')
                    .replaceAll('"', '')
                    .replaceAll('<', '')
                    .replaceAll('>', '')
                    .replaceAll('|', '');

                // Display info about this video.
                // ignore: use_build_context_synchronously
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        'Title: ${video.title}, Duration: ${video.duration}',
                      ),
                    );
                  },
                );

                // Request permission to write in an external directory.
                // (In this case downloads)
                await Permission.storage.request();

                // Get the streams manifest and the audio track.
                final manifest = await yt.videos.streamsClient.getManifest(id);
                final audio = manifest.audioOnly.withHighestBitrate();
                final videof = manifest.videoOnly.bestQuality;
                //========================================================================================================
                final dir = await DownloadsPath.downloadsDirectory();
                //========================== DOWNLOAD Audio ONLY==============================================================================
                // Build the directory.
                final filePath = path.join(
                  dir!.uri.toFilePath(),
                  '${video.id}.${audio.container.name}',
                );
                // Open the file to write.
                final file = File(filePath);
                // Delete the file if exists.
                if (file.existsSync()) {
                  file.deleteSync();
                }
                final fileStream = file.openWrite();

                // Pipe all the content of the stream into our file.
                await yt.videos.streamsClient.get(audio).pipe(fileStream);
                /*
                  If you want to show a % of download, you should listen
                  to the stream instead of using `pipe` and compare
                  the current downloaded streams to the totalBytes,
                  see an example ii example/video_download.dart
                   */

                // Close the file.
                await fileStream.flush();
                await fileStream.close();
                //========================== DOWNLOAD Video Only==============================================================================
                // Build the directory.
                final filePathVideo = path.join(
                  dir.uri.toFilePath(),
                  '${video.id}.mp4',
                );
                // Open the file to write.
                final fileVideo = File(filePathVideo);
                // Delete the file if exists.
                if (fileVideo.existsSync()) {
                  fileVideo.deleteSync();
                }
                final fileStreamVideo = fileVideo.openWrite();

                // Pipe all the content of the stream into our file.
                await yt.videos.streamsClient.get(videof).pipe(fileStreamVideo);

                // Close the file.
                await fileStreamVideo.flush();
                await fileStreamVideo.close();
                //export video Premium ==========================MERGE VIDEO AND AUDIO==============================================================================
                // Build the directory.
                final filePathmerge = path.join(
                  dir.uri.toFilePath(),
                  '${video.id}_79thantai.com.mp4',
                );
                // Excecute Merge
                FFmpegKit.execute(
                        '-i $filePathVideo -i $filePath -c copy -map 0:v:0 -map 1:a:0 $filePathmerge'
                        //'-i $videoroot -i $audioroot -c:v copy -c:a copy $filePathmerge'
                        )
                    .then((session) async {
                  final returnCode = await session.getReturnCode();

                  if (ReturnCode.isSuccess(returnCode)) {
                    if (kDebugMode) {
                      print('SUCCESS 369');
                      fileVideo.delete();
                      file.delete();
                    }
                  } else if (ReturnCode.isCancel(returnCode)) {
                    // CANCEL
                  } else {
                    // ERROR
                  }
                });

                // Show that the file was downloaded.
                // ignore: use_build_context_synchronously
                await showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                          'Download completed and saved to: $filePathmerge'),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
