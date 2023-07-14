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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDY0MczzW8b_VwTn1vDf6Ty_wbq96S5doE',
    appId: '1:275981907707:web:d83bb05b193b06e567625e',
    messagingSenderId: '275981907707',
    projectId: 'sumcoin-wallet',
    authDomain: 'sumcoin-wallet.firebaseapp.com',
    storageBucket: 'sumcoin-wallet.appspot.com',
    measurementId: 'G-YBQ3XDQ5ZD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBrHJuzREfLjQbPm1DRe-qCdJNaaAoKbfk',
    appId: '1:275981907707:android:6e2c2a3b4b42f09567625e',
    messagingSenderId: '275981907707',
    projectId: 'sumcoin-wallet',
    storageBucket: 'sumcoin-wallet.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDoKNtI_Whvaz_GoeWOasTxGdow6H6Cngg',
    appId: '1:275981907707:ios:8e4ea442d06c60c267625e',
    messagingSenderId: '275981907707',
    projectId: 'sumcoin-wallet',
    storageBucket: 'sumcoin-wallet.appspot.com',
    iosClientId: '275981907707-vfvl2kfc7jd0n5d8un4tp3qed6v4gd84.apps.googleusercontent.com',
    iosBundleId: 'com.sumcoinwallet',
  );
}
