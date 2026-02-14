import 'package:flutter/foundation.dart' show kIsWeb;

import 'att_helper_stub.dart'
    if (dart.library.io) 'att_helper_mobile.dart' as att_impl;

class AttHelper {
  static Future<void> requestTrackingIfNeeded() async {
    if (kIsWeb) return;
    await att_impl.requestTracking();
  }
}
