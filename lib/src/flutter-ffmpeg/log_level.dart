class LogLevel {
  ///
  /// This log level is used to specify logs printed to stderr by ffmpeg.
  /// Logs that has this level are not filtered and always redirected.
  static const int avLogSTDERR = -16;

  /// Print no output.
  static const int avLogQUIET = -8;

  /// Something went really wrong and we will crash now.
  static const int avLogPANIC = 0;

  /// Something went wrong and recovery is not possible.
  /// For example, no header was found for a format which depends
  /// on headers or an illegal combination of parameters is used.
  static const int avLogFATAL = 8;

  /// Something went wrong and cannot losslessly be recovered.
  /// However, not all future data is affected.
  static const int avLogERROR = 16;

  /// Something somehow does not look correct. This may or may not
  /// lead to problems. An example would be the use of '-vstrict -2'.
  static const int avLogWARNING = 24;

  /// int Standard information.
  static const int avLogINFO = 32;

  /// Detailed information.
  static const int avLogVERBOSE = 40;

  /// Stuff which is only useful for libav* developers.
  static const int avLogDEBUG = 48;

  /// Extremely verbose debugging, useful for libav* development.
  static const int avLogTRACE = 56;

  /// Returns log level string from int
  static String levelToString(int level) {
    switch (level) {
      case LogLevel.avLogTRACE:
        return "TRACE";
      case LogLevel.avLogDEBUG:
        return "DEBUG";
      case LogLevel.avLogVERBOSE:
        return "VERBOSE";
      case LogLevel.avLogINFO:
        return "INFO";
      case LogLevel.avLogWARNING:
        return "WARNING";
      case LogLevel.avLogERROR:
        return "ERROR";
      case LogLevel.avLogFATAL:
        return "FATAL";
      case LogLevel.avLogPANIC:
        return "PANIC";
      case LogLevel.avLogSTDERR:
        return "STDERR";
      case LogLevel.avLogQUIET:
      default:
        return "";
    }
  }
}
