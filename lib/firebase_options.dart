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
    apiKey: 'AIzaSyANWmEX-Dr9TjJ7Rls4zGMgjUAFrV_idcU',
    appId: '1:492279378208:web:32be321eaaeffe5ae56745',
    messagingSenderId: '492279378208',
    projectId: 'max-ecommerce-app',
    authDomain: 'max-ecommerce-app.firebaseapp.com',
    storageBucket: 'max-ecommerce-app.appspot.com',
    measurementId: 'G-M3EG4T0LT8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDJOzIBA1wzoUjIlIbaxGXAztAFhK2QMnc',
    appId: '1:492279378208:android:d70080eab6ad6dc1e56745',
    messagingSenderId: '492279378208',
    projectId: 'max-ecommerce-app',
    storageBucket: 'max-ecommerce-app.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD3XtGG2AgyV9wOqVx5WhzEsUr0WWZxNm4',
    appId: '1:492279378208:ios:526d4b2a1edbe245e56745',
    messagingSenderId: '492279378208',
    projectId: 'max-ecommerce-app',
    storageBucket: 'max-ecommerce-app.appspot.com',
    iosClientId: '492279378208-9l4ig99k41dldhijvt1nstshnf5qko8d.apps.googleusercontent.com',
    iosBundleId: 'com.example.maxEcommerceApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD3XtGG2AgyV9wOqVx5WhzEsUr0WWZxNm4',
    appId: '1:492279378208:ios:526d4b2a1edbe245e56745',
    messagingSenderId: '492279378208',
    projectId: 'max-ecommerce-app',
    storageBucket: 'max-ecommerce-app.appspot.com',
    iosClientId: '492279378208-9l4ig99k41dldhijvt1nstshnf5qko8d.apps.googleusercontent.com',
    iosBundleId: 'com.example.maxEcommerceApp',
  );
}
