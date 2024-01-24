class FFmpegExecution {
  int executionId;
  DateTime startTime;
  String command;

  FFmpegExecution(
      {required this.command,
      required this.executionId,
      required this.startTime});
}
