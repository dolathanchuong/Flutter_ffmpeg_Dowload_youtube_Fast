/// Represents a completed FFmpeg execution.
class CompletedFFmpegExecution {
  int executionId;
  int returnCode;

  CompletedFFmpegExecution(this.executionId, this.returnCode);
}
