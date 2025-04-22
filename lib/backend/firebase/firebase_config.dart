import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyATn7fn0matPz7miPJJSYHIPT18ujnyGmU",
            authDomain: "not-idea-5rcvx4.firebaseapp.com",
            projectId: "not-idea-5rcvx4",
            storageBucket: "not-idea-5rcvx4.firebasestorage.app",
            messagingSenderId: "1025532254047",
            appId: "1:1025532254047:web:4ec960c650ff0cdbe388ea"));
  } else {
    await Firebase.initializeApp();
  }
}
