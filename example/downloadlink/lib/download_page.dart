import 'dart:io';

//import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:youtubedart/youtube_explode_dart.dart';

class DownloadPage extends StatefulWidget {
  const DownloadPage({super.key});

  @override
  DownloadPageState createState() => DownloadPageState();
}

class DownloadPageState extends State<DownloadPage> {
  final textController = TextEditingController();
  String downloadMessage = 'Download...';
  bool isDownloading = false;
  double percentageGl = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Text(
            'Insert the video id or url',
          ),
          Padding(
            padding: const EdgeInsets.all(9.0),
            child: TextField(controller: textController),
          ),
          FloatingActionButton.extended(
            onPressed: () async {
              setState(() {
                isDownloading = !isDownloading;
              });
              downloadMessage = '1';

              ///
              final yt = YoutubeExplode();
              downloadMessage = '2';
              final id = VideoId(textController.text.trim());
              downloadMessage = '3';
              try {
                final video1 = await yt.videos.get(id);
                if (kDebugMode) {
                  downloadMessage = video1.id.toString();
                }
              } catch (e) {
                if (kDebugMode) {
                  downloadMessage = 'Error: $e';
                }
              }
              final video = await yt.videos.get(id);

              downloadMessage = '4';
              final StreamManifest manifestroot =
                  await yt.videos.streamsClient.getManifest(id);
              final audio = manifestroot.audioOnly.withHighestBitrate();
              //final audioroot = manifestroot.audioOnly.first.url.toString();

              ///
              await Permission.storage.request();
              var dir = await DownloadsPath.downloadsDirectory();
              downloadMessage = '3 ${dir!.path}';
              //=============DownLoad DIO ==================================
              // Dio dio = Dio();
              // await dio.download(
              //     audioroot, '${dir!.uri.toFilePath()}/${video.id}.mp3',
              //     onReceiveProgress: (actualbytes, totalbytes) {
              //   var percentage = actualbytes / totalbytes * 100;
              //   if (percentage < 100) {
              //     percentageGl = percentage / 100;
              //     setState(() {
              //       downloadMessage = 'Downloading... ${percentage.floor()} %';
              //     });
              //   } else {
              //     downloadMessage = 'Successfull downloaded!';
              //   }
              // });
              //========================== DOWNLOAD Audio ONLY==============================================================================
              // Build the directory.
              final filePath = path.join(
                dir.uri.toFilePath(),
                '${video.id}.${audio.container.name}',
              );
              // Open the file to write.
              final file = File(filePath);
              // Delete the file if exists.
              if (file.existsSync()) {
                file.deleteSync();
              }
              final fileStream = file.openWrite(mode: FileMode.writeOnlyAppend);
              // Track the file download status.
              final len = audio.size.totalBytes;
              var count = 0;
              // Create the message and set the cursor position.
              final msg = 'Downloading ${video.title}.${audio.container.name}';
              stdout.writeln(msg);
              final audioStream = yt.videos.streamsClient.get(audio);
              await for (final data in audioStream) {
                // Keep track of the current downloaded data.
                count += data.length;
                final progress = ((count / len) * 100).clamp(0, 100);

                setState(() {
                  percentageGl = progress / 100;
                  downloadMessage = (progress < 100)
                      ? 'Downloading... ${progress.floor()} %'
                      : 'Successfully downloaded!';
                });
                // // Calculate the current progress.
                // // final progress = ((count / len) * 100).ceil();
                // final progress = ((count / len) * 100);

                // if (progress < 100) {
                //   // Update the progressbar.
                //   setState(() {
                //     percentageGl = progress / 100;
                //   });
                //   setState(() {
                //     downloadMessage = 'Downloading... ${progress.floor()} %';
                //   });
                // } else {
                //   downloadMessage = 'Successfull downloaded!';
                // }

                // Write to file.
                fileStream.add(data);
              }
              if (kDebugMode) {
                print(dir.path);
              }
              // Close the file.
              await fileStream.flush();
              await fileStream.close();
            },
            label: const Text('Pull'),
            icon: const Icon(Icons.file_download),
          ),
          const SizedBox(height: 32),
          Text(
            downloadMessage,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              value: percentageGl,
            ),
          )
        ],
      )),
    );
  }
}
