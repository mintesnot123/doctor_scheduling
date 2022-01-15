import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/auth/register.dart';
import 'package:yismaw/pages/auth/forgotPasswordPage.dart';
import 'package:yismaw/pages/auth/emailVerificationPage.dart';
import 'package:yismaw/pages/adminPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  bool loggingin = false;

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    return ModalProgressHUD(
        inAsyncCall: loggingin,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, true, Icons.login_rounded), //let's create a common header widget
                ),
                SafeArea(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10), // This will be the login form
                      child: Column(
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Signin into your account',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 30.0),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    child: TextFormField(
                                      decoration: ThemeHelper().textInputDecoration('User Name', 'Enter your user name'),
                                      validator: (value) {
                                        if (value.isEmpty || !value.contains('@')) {
                                          return 'Please enter a valid email.';
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      //autofocus: false,
                                      controller: emailController,
                                      //textInputAction: TextInputAction.next,
                                      //onEditingComplete: () => node.nextFocus(),
                                      obscureText: false,
                                    ),
                                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    child: TextFormField(
                                      obscureText: true,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a password.';
                                        } else if (value.length < 8) {
                                          return 'Password must be atleast 8 char.';
                                        }
                                        return null;
                                      },
                                      controller: passwordController,
                                      //textInputAction: TextInputAction.done,
                                      //onEditingComplete: () {},
                                      /* onFieldSubmitted: (v) {
                                        FocusScope.of(context).requestFocus(node);
                                      }, */
                                      decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                    ),
                                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                                        );
                                      },
                                      child: Text(
                                        "Forgot your password?",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: ThemeHelper().buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: Text(
                                          'Sign In'.toUpperCase(),
                                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          _signIn();
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    //child: Text('Don\'t have an account? Create'),
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(text: "Don\'t have an account? "),
                                      TextSpan(
                                        text: 'Create',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterPage()));
                                          },
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                      ),
                                    ])),
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ));
  }

  void _signIn() async {
    User user;
    UserCredential credential;

    setState(() {
      loggingin = true;
    });

    try {
      credential = await _firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", processError(error), context);
        },
      );
      setState(() {
        loggingin = false;
      });
    }
    user = credential.user;

    if (user != null) {
      if (!user.emailVerified) {
        try {
          await user.sendEmailVerification();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmailVerificationPage(user: user)),
          );
        } catch (error) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ThemeHelper().alartDialog("Error", error.message, context);
            },
          );
          setState(() {
            loggingin = false;
          });
        }
      } else {
        setState(() {
          loggingin = false;
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
      }
    } else {
      setState(() {
        loggingin = false;
      });
    }
  }

  String processError(final dynamic error) {
    String messageVar = "";
    if (error.code == "user-not-found") {
      messageVar = "Unable to find user. Please register.";
    } else if (error.code == "wrong-password") {
      messageVar = "Incorrect password.";
    } else {
      messageVar = "There was an error logging in. Please try again later.";
    }
    return messageVar;
  }
}
