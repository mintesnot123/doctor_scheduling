import 'package:yismaw/widgets/customtextinput.dart';
import 'package:yismaw/widgets/custombutton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';

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

  void onChange() {
    setState(() {
      _errorMessage = '';
    });
  }

  bool loggingin = false;

  /* @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);

    final logo = Hero(
      tag: 'heroicon',
      child: Icon(
        Icons.medical_services,
        size: 120,
        color: Colors.deepPurple[900],
      ),
    );

    final logoText = Hero(
      tag: 'HeroTitle',
      child: Text(
        'My Doctor',
        style: TextStyle(color: Colors.deepPurple[900], fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w700),
      ),
    );

    final errorMessage = Padding(
      padding: EdgeInsets.all(1.0),
      child: Text(
        '$_errorMessage',
        style: TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    final email = CustomTextInput(
      hintText: 'Email',
      leading: Icons.mail,
      obscure: false,
      keyboard: TextInputType.emailAddress,
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email.';
        }
        return null;
      },
      controller: emailController,
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
      onFieldSubmitted: () {},
    );

    final password = CustomTextInput(
      hintText: 'Password',
      leading: Icons.lock,
      obscure: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a password.';
        } else if (value.length < 8) {
          return 'Password must be atleast 8 char.';
        }
        return null;
      },
      controller: passwordController,
      textInputAction: TextInputAction.done,
      onEditingComplete: () {},
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(node);
      },
    );

    final loginButton = Hero(
      tag: 'loginbutton',
      child: CustomButton(
        text: 'login',
        accentColor: Colors.white,
        mainColor: Colors.deepPurple,
        onpress: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              loggingin = true;
            });
            try {
              UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
              setState(() {
                loggingin = false;
              });
              Navigator.of(context).pushNamed('/home');
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
    );

    final forgotLabel = GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/');
      },
      child: Text(
        'Forgot password?',
        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.deepPurple),
      ),
    );

    final registerButton = GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(context, '/register');
      },
      child: Text(
        'create an account',
        style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.deepPurple),
      ),
    );

    final footer = Hero(
      tag: 'footer',
      child: Text(
        'Made with ♥ by Horizon Tech',
        style: TextStyle(fontFamily: 'Poppins'),
      ),
    );

    return ModalProgressHUD(
      inAsyncCall: loggingin,
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            // margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.2),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    logo,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    logoText,
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                    errorMessage,
                    email,
                    SizedBox(
                      height: 0,
                    ),
                    password,
                    SizedBox(
                      height: 30,
                    ),
                    loginButton,
                    SizedBox(
                      height: 5,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      forgotLabel,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.1,
                      ),
                      registerButton
                    ]),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    footer,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  } */
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);
    return Scaffold(
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
                                ),
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextField(
                                  obscureText: true,
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
                                    /* Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), ); */
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
                                  onPressed: () {
                                    //After successful login we will redirect to profile page. Let's create profile page now
                                    /* Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage())); */
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
                                        /* Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage())); */
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
    );
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
