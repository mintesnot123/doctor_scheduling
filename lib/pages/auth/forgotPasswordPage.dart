import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/auth/forgotPasswordVerificationPage.dart';
import 'package:yismaw/pages/auth/login.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();

  bool sendingResetEmail = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;
    return ModalProgressHUD(
        inAsyncCall: sendingResetEmail,
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: _headerHeight,
                    child: HeaderWidget(_headerHeight, true, Icons.password_rounded),
                  ),
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Forgot Password?',
                                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Enter the email address associated with your account.',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'We will email you a verification code to check your authenticity.',
                                  style: TextStyle(
                                    color: Colors.black38,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: TextFormField(
                                    decoration: ThemeHelper().textInputDecoration("Email", "Enter your email"),
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return "Email can't be empty";
                                      } else if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)) {
                                        return "Enter a valid email address";
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: false,
                                    controller: emailController,
                                  ),
                                  decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                ),
                                SizedBox(height: 40.0),
                                Container(
                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: Text(
                                        "Send".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        _sendPasswordResetEmail();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: "Remember your password? "),
                                      TextSpan(
                                        text: 'Login',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => LoginPage()),
                                            );
                                          },
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )));
  }

  void _sendPasswordResetEmail() async {
    setState(() {
      sendingResetEmail = true;
    });
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: emailController.text);
      final snackBar = SnackBar(
        content: Text('password reset email sent!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ForgotPasswordVerificationPage()),
      );
      setState(() {
        sendingResetEmail = false;
      });
    } on FirebaseAuthException catch (e) {
      /* print(e.code);
      print(e.message); */
      /* final snackBar = SnackBar(
        content: Text(e.message),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar); */
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", e.message, context);
        },
      );
      setState(() {
        sendingResetEmail = false;
      });
    }
  }
}
