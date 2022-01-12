import 'package:yismaw/widgets/customtextinput.dart';
import 'package:yismaw/widgets/custombutton.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:edge_alert/edge_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yismaw/pages/login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  String _errorMessage = '';

  void processError(final FirebaseAuthException error) {
    setState(() {
      _errorMessage = error.message;
    });
  }

  /* void onChange() {
    setState(() {
      _errorMessage = '';
    });
  } */

  bool signingup = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* final node = FocusScope.of(context);

    emailController.addListener(onChange);
    passwordController.addListener(onChange);
 */
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

    final name = CustomTextInput(
      hintText: 'Full Name',
      leading: Icons.text_format,
      obscure: false,
      keyboard: TextInputType.text,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your name.';
        }
        return null;
      },
      controller: nameController,
      textInputAction: TextInputAction.next,
      focusNode: _nameFocus,
      onFieldSubmitted: (term) {
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      onEditingComplete: () {},
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
      focusNode: _emailFocus,
      onFieldSubmitted: (term) {
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      onEditingComplete: () {},
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
      /* onEditingComplete: () {},
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(node);
      }, */
    );

    final signUpButton = Hero(
      tag: 'signupbutton',
      child: CustomButton(
        text: 'sign up',
        accentColor: Colors.white,
        mainColor: Colors.deepPurple,
        onpress: () async {
          if (_formKey.currentState.validate()) {
            _registerAccount();
          }
        },
      ),
    );

    final loginButton = GestureDetector(
      onTap: () {
        _pushPage(context, LoginPage());
      },
      child: Text(
        'or log in instead',
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
      inAsyncCall: signingup,
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
                    name,
                    SizedBox(
                      height: 0,
                    ),
                    email,
                    SizedBox(
                      height: 0,
                    ),
                    password,
                    SizedBox(
                      height: 30,
                    ),
                    signUpButton,
                    SizedBox(
                      height: 5,
                    ),
                    loginButton,
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
  }

  void _registerAccount() async {
    User user;
    UserCredential credential;

    setState(() {
      signingup = true;
    });

    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    } catch (error) {
      processError(error);
      setState(() {
        signingup = false;
      });
    }
    user = credential.user;

    if (user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
      await user.updateProfile(displayName: nameController.text);

      _firestore.collection('users').doc(user.uid).set({
        'name': nameController.text,
        'birthDate': null,
        'email': emailController.text,
        'phone': null,
        'bio': null,
        'city': null,
      }, SetOptions(merge: true));

      Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      setState(() {
        signingup = false;
      });
    } else {
      setState(() {
        signingup = false;
      });
    }
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
