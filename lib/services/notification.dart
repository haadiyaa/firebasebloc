import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}

class PushNotification {
  final _firebaseMessaging=FirebaseMessaging.instance;
  Future<void> initNotification()async{
    await _firebaseMessaging.requestPermission();
    final token=await _firebaseMessaging.getToken();
    print("TOKEN: $token");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
