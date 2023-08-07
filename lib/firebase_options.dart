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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSphT1eMQwJwMOSMEwiqjjxWYhf8P7uAg',
    appId: '1:873201450154:android:5e0d1a1a0b7e8eaf9624d3',
    messagingSenderId: '873201450154',
    projectId: 'animation-demo-3bc8b',
    storageBucket: 'animation-demo-3bc8b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA7IaFt75a0zK_0Oe4T8LWx2Pcuv3uFAoA',
    appId: '1:873201450154:ios:22947dbb60924daa9624d3',
    messagingSenderId: '873201450154',
    projectId: 'animation-demo-3bc8b',
    storageBucket: 'animation-demo-3bc8b.appspot.com',
    iosClientId: '873201450154-3j0mnpl5auu4973vvorckr9n4e4tk2iv.apps.googleusercontent.com',
    iosBundleId: 'com.mobile.vtc.smartAgent.alpha',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA7IaFt75a0zK_0Oe4T8LWx2Pcuv3uFAoA',
    appId: '1:873201450154:ios:8c131121dcece1229624d3',
    messagingSenderId: '873201450154',
    projectId: 'animation-demo-3bc8b',
    storageBucket: 'animation-demo-3bc8b.appspot.com',
    iosClientId: '873201450154-88ll7o31i2fb82h9fgbimpobq3lgu2kp.apps.googleusercontent.com',
    iosBundleId: 'com.example.animationDemo',
  );
}