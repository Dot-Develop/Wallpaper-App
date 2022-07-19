import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wallyapp/screens/home_screen.dart';
import 'package:wallyapp/screens/signin_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primaryColor: Color(0xFF595854),
        accentColor: Color(0xFF00ffa7),
        brightness: Brightness.dark,
        fontFamily: 'bitter',
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print('onMessage: $message');
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print('onLaunch: $message');
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print('onResume: $message');
//      },
//    );
    //_firebaseMessaging.subscribeToTopic('promotion');
  }

//  void initDynamicLinks() async {
//    FirebaseDynamicLinks.instance.onLink(
//        onSuccess: (PendingDynamicLinkData dynamicLink) async {
//      final Uri deepLink = dynamicLink?.link;
//      if (deepLink != null) {
//        print(deepLink);
//      }
//    }, onError: (OnLinkErrorException e) async {
//      print('onLinkError');
//      print(e.message);
//    });
//  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            if (user != null) {
              return HomeScreen();
            } else {
              return SigninScreen();
            }
          }
          return SigninScreen();
        });
  }
}
