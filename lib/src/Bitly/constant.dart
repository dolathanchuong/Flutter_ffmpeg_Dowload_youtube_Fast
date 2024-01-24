///
/// The Bitly V4 API follows the more standard REST convention of utilizing
/// the HTTP response codes to identify the status of the response.
/// These include, but are not limited to [StatusCode]
///
class StatusCode {
  static const sUCCESS = 200;
  static const cREATED = 201;
  static const bADrEQUEST = 400;
  static const fORbIDDEN = 401;
  static const eXPECTATIONfAILED = 417;
  static const uNPROCESSABLEeNTITY = 422;
  static const iNTERNALeRROR = 500;
  static const tEMPORARILYuNAVAILABLE = 503;
}
