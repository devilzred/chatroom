// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBsJ7DgIPJo_Di18duYZI4Pbqrbs5EglV4',
    appId: '1:407038809317:web:b331c9c945f5acc936b00c',
    messagingSenderId: '407038809317',
    projectId: 'chatroom-e9663',
    authDomain: 'chatroom-e9663.firebaseapp.com',
    storageBucket: 'chatroom-e9663.appspot.com',
    measurementId: 'G-BCVWDQBRSE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCHRmtPb2QY9hOHz93mg_C0p_lXpw_h-o4',
    appId: '1:407038809317:android:e594c35b48b20cdc36b00c',
    messagingSenderId: '407038809317',
    projectId: 'chatroom-e9663',
    storageBucket: 'chatroom-e9663.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA877QTdSNo1_Pqmj441Z-4ryDYr1yi8N4',
    appId: '1:407038809317:ios:ea64737803a756be36b00c',
    messagingSenderId: '407038809317',
    projectId: 'chatroom-e9663',
    storageBucket: 'chatroom-e9663.appspot.com',
    iosBundleId: 'com.example.chatroom',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA877QTdSNo1_Pqmj441Z-4ryDYr1yi8N4',
    appId: '1:407038809317:ios:ea64737803a756be36b00c',
    messagingSenderId: '407038809317',
    projectId: 'chatroom-e9663',
    storageBucket: 'chatroom-e9663.appspot.com',
    iosBundleId: 'com.example.chatroom',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBsJ7DgIPJo_Di18duYZI4Pbqrbs5EglV4',
    appId: '1:407038809317:web:557ce2351c75994b36b00c',
    messagingSenderId: '407038809317',
    projectId: 'chatroom-e9663',
    authDomain: 'chatroom-e9663.firebaseapp.com',
    storageBucket: 'chatroom-e9663.appspot.com',
    measurementId: 'G-KLZZ8VNVY4',
  );

}