import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninScreen extends StatefulWidget {
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _db = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Home Page'),
//      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Image(
              height: MediaQuery.of(context).size.height,
              image: AssetImage('assets/bg.jpg'),
              fit: BoxFit.cover,
            ),
            Container(
              margin: EdgeInsets.only(top: 80.0),
              width: MediaQuery.of(context).size.width,
              child: Image(
                width: 200,
                height: 200,
                image: AssetImage('assets/logo_circle.png'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xFF000000),
                  Color(0x00000000),
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
            ),
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18)),
                  color: Colors.red,
                  onPressed: () {
                    _signIn();
                  },
                  child: Text('Google Sign In'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("signed in " + user.displayName);

      _db.collection('users').document(user.uid).setData({
        'displayName': _googleSignIn.currentUser.displayName,
        'email': _googleSignIn.currentUser.email,
        'uid': user.uid,
        'photoUrl': _googleSignIn.currentUser.photoUrl,
        'lastSignIn': DateTime.now(),
      }, merge: true);
    } catch (error) {
      print(error);
    }
  }
}
