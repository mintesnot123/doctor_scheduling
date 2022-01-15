import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yismaw/pages/adminPage.dart';
import 'package:yismaw/pages/adminPage.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/register.dart';
import 'package:yismaw/pages/auth/forgotPasswordPage.dart';

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

  String _errorMessage = '';

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
                                          setState(() {
                                            loggingin = true;
                                          });
                                          try {
                                            UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                                            setState(() {
                                              loggingin = false;
                                            });
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
                                          } on FirebaseAuthException catch (e) {
                                            processError(e);
                                            setState(() {
                                              loggingin = false;
                                            });
                                            EdgeAlert.show(context, title: 'Login Failed', description: e.toString(), gravity: EdgeAlert.BOTTOM, icon: Icons.error, backgroundColor: Colors.deepPurple[900]);
                                          }
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

  void processError(final FirebaseAuthException error) {
    if (error.code == "user-not-found") {
      setState(() {
        _errorMessage = "Unable to find user. Please register.";
      });
    } else if (error.code == "wrong-password") {
      setState(() {
        _errorMessage = "Incorrect password.";
      });
    } else {
      setState(() {
        _errorMessage = "There was an error logging in. Please try again later.";
      });
    }
  }
}
