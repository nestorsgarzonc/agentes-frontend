// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBsMUdIG1CwD_jRGS95rZGghYBp4le4roo',
    appId: '1:111373113185:web:557c0f86c897c0c6945720',
    messagingSenderId: '111373113185',
    projectId: 'on-your-table',
    authDomain: 'on-your-table.firebaseapp.com',
    databaseURL: 'https://on-your-table-default-rtdb.firebaseio.com',
    storageBucket: 'on-your-table.appspot.com',
    measurementId: 'G-1RE825RLKT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5hpf00nyHGOXkkyzvMEgu4gVA3OIIbrs',
    appId: '1:111373113185:android:d45200a2ff16dff4945720',
    messagingSenderId: '111373113185',
    projectId: 'on-your-table',
    databaseURL: 'https://on-your-table-default-rtdb.firebaseio.com',
    storageBucket: 'on-your-table.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDpsDnisazQOONYD6YHRhkEuu9S2NcgHyo',
    appId: '1:111373113185:ios:250bb18f829106e2945720',
    messagingSenderId: '111373113185',
    projectId: 'on-your-table',
    databaseURL: 'https://on-your-table-default-rtdb.firebaseio.com',
    storageBucket: 'on-your-table.appspot.com',
    iosClientId: '111373113185-ffctg19np6s31gks9husb5g941qtec69.apps.googleusercontent.com',
    iosBundleId: 'com.oyt.oytDiner',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDpsDnisazQOONYD6YHRhkEuu9S2NcgHyo',
    appId: '1:111373113185:ios:f8f81841aff59644945720',
    messagingSenderId: '111373113185',
    projectId: 'on-your-table',
    databaseURL: 'https://on-your-table-default-rtdb.firebaseio.com',
    storageBucket: 'on-your-table.appspot.com',
    iosClientId: '111373113185-97qvniggf93uvm87dc21sk3425ktjmsp.apps.googleusercontent.com',
    iosBundleId: 'com.nw.restaurants',
  );
}
