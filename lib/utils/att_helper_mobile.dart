import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

Future<void> requestTracking() async {
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(seconds: 1));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
}
