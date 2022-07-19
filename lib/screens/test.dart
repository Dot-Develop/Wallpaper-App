//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
//class Test extends StatefulWidget {
//  @override
//  _TestState createState() => _TestState();
//}
//
//class _TestState extends State<Test> {
//  final TextEditingController _smsController = TextEditingController();
//  String _message;
//  String _verificationId;
//  bool _isSMSsent = false;
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//
//  PhoneNumber _phoneNumber;
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('Phone Sign in'),
//      ),
//      body: SingleChildScrollView(
//        child: AnimatedContainer(
//          duration: Duration(milliseconds: 500),
//          margin: EdgeInsets.only(top: 40.0),
//          width: MediaQuery.of(context).size.width,
//          child: Column(
//            children: <Widget>[
//              Container(
//                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//                child: InternationalPhoneNumberInput(
//                  onInputChanged: (phoneNumber) {
//                    _phoneNumber = phoneNumber;
//                  },
//                  inputBorder: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(16.0),
//                  ),
//                ),
//              ),
//              _isSMSsent
//                  ? Container(
//                      margin: EdgeInsets.all(12.0),
//                      child: TextField(
//                        controller: _smsController,
//                        decoration: InputDecoration(
//                          border: OutlineInputBorder(
//                            borderRadius: BorderRadius.circular(16.0),
//                          ),
//                          labelText: 'Verification Code',
//                          hintText: 'Enter verification code here',
//                        ),
//                        maxLength: 6,
//                        keyboardType: TextInputType.number,
//                      ),
//                    )
//                  : Container(),
//              !_isSMSsent
//                  ? InkWell(
//                      onTap: () {
//                        setState(() {
//                          _isSMSsent = true;
//                        });
//                        _verifyPhoneNumber();
//                      },
//                      child: Container(
//                        margin: EdgeInsets.symmetric(
//                            horizontal: 30.0, vertical: 20.0),
//                        padding: EdgeInsets.symmetric(
//                            horizontal: 30, vertical: 20.0),
//                        width: MediaQuery.of(context).size.width,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(16),
//                          gradient: LinearGradient(
//                            colors: [
//                              Colors.green,
//                              Colors.greenAccent,
//                            ],
//                          ),
//                        ),
//                        child: Center(
//                          child: Text(
//                            'Send Verification Code',
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 16.0,
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
//                        ),
//                      ),
//                    )
//                  : InkWell(
//                      onTap: () {
//                        _signInWithPhoneNumber();
//                      },
//                      child: Container(
//                        margin: EdgeInsets.symmetric(
//                            horizontal: 30.0, vertical: 20.0),
//                        padding: EdgeInsets.symmetric(
//                            horizontal: 30, vertical: 20.0),
//                        width: MediaQuery.of(context).size.width,
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(16),
//                          gradient: LinearGradient(
//                            colors: [
//                              Colors.green,
//                              Colors.greenAccent,
//                            ],
//                          ),
//                        ),
//                        child: Center(
//                          child: Text(
//                            'Verify',
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 16.0,
//                              fontWeight: FontWeight.bold,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  void _verifyPhoneNumber() async {
//    setState(() {
//      _message = '';
//    });
//
//    final PhoneVerificationCompleted verificationCompleted =
//        (AuthCredential phoneAuthCredential) {
//      _auth.signInWithCredential(phoneAuthCredential);
//      setState(() {
//        _message = 'Received phone auth credential: $phoneAuthCredential';
//      });
//    };
//
//    final PhoneVerificationFailed verificationFailed =
//        (AuthException authException) {
//      setState(() {
//        _message =
//            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
//      });
//    };
//
//    final PhoneCodeSent codeSent =
//        (String verificationId, [int forceResendingToken]) async {
//      _verificationId = verificationId;
//    };
//
//    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
//        (String verificationId) {
//      _verificationId = verificationId;
//    };
//
//    await _auth.verifyPhoneNumber(
//        phoneNumber: _phoneNumber.phoneNumber,
//        timeout: const Duration(seconds: 120),
//        verificationCompleted: verificationCompleted,
//        verificationFailed: verificationFailed,
//        codeSent: codeSent,
//        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
//  }
//
//  // Example code of how to sign in with phone.
//  void _signInWithPhoneNumber() async {
//    final AuthCredential credential = PhoneAuthProvider.getCredential(
//      verificationId: _verificationId,
//      smsCode: _smsController.text,
//    );
//    final FirebaseUser user =
//        (await _auth.signInWithCredential(credential)).user;
//    final FirebaseUser currentUser = await _auth.currentUser();
//    assert(user.uid == currentUser.uid);
//    setState(() {
//      if (user != null) {
////        _db.collection('users').document(user.uid).setData({
////          'phoneNumber': user.phoneNumber,
////          'lastSeen': DateTime.now(),
////          'signin_method': user.providerId,
////        });
//
//        _message = 'Successfully signed in, uid: ' + user.uid;
//        print(_message);
//      } else {
//        _message = 'Sign in failed';
//      }
//    });
//
//    Navigator.pop(context);
//  }
//}
