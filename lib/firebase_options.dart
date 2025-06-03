import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyChJqhQ5ONDRf3Puy70XwNEv39ASCFOZjE',
    appId: '1:1018032806208:web:fdfa5b590603445f6c02a5',
    messagingSenderId: '1018032806208',
    projectId: 'library-app-5f40a',
    authDomain: 'library-app-5f40a.firebaseapp.com',
    storageBucket: 'library-app-5f40a.firebasestorage.app',
    measurementId: 'G-M1J3699ZE1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyChJqhQ5ONDRf3Puy70XwNEv39ASCFOZjE',
    appId: '1:1018032806208:android:YOUR_ANDROID_APP_ID',
    messagingSenderId: '1018032806208',
    projectId: 'library-app-5f40a',
    storageBucket: 'library-app-5f40a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChJqhQ5ONDRf3Puy70XwNEv39ASCFOZjE',
    appId: '1:1018032806208:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '1018032806208',
    projectId: 'library-app-5f40a',
    storageBucket: 'library-app-5f40a.firebasestorage.app',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.kutuphaneApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChJqhQ5ONDRf3Puy70XwNEv39ASCFOZjE',
    appId: '1:1018032806208:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: '1018032806208',
    projectId: 'library-app-5f40a',
    storageBucket: 'library-app-5f40a.firebasestorage.app',
    iosClientId: 'YOUR_MACOS_CLIENT_ID',
    iosBundleId: 'com.example.kutuphaneApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyChJqhQ5ONDRf3Puy70XwNEv39ASCFOZjE',
    appId: '1:1018032806208:windows:YOUR_WINDOWS_APP_ID',
    messagingSenderId: '1018032806208',
    projectId: 'library-app-5f40a',
    storageBucket: 'library-app-5f40a.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyChJqhQ5ONDRf3Puy70XwNEv39ASCFOZjE',
    appId: '1:1018032806208:linux:YOUR_LINUX_APP_ID',
    messagingSenderId: '1018032806208',
    projectId: 'library-app-5f40a',
    storageBucket: 'library-app-5f40a.firebasestorage.app',
  );
} 