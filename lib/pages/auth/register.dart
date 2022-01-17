import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yismaw/pages/auth/login.dart';
import 'package:yismaw/pages/auth/emailVerificationPage.dart';
import 'package:yismaw/pages/mainPage.dart';
import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  bool signingup = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool checkedValue = false;
  bool checkboxValue = false;

  String type = "doctor";
  String _registorAs = "doctor";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: signingup,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Stack(
              children: [
                Container(
                  height: 150,
                  child: HeaderWidget(150, false, Icons.person_add_alt_1_rounded),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(width: 5, color: Colors.white),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 20,
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey.shade300,
                                      size: 80.0,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.grey.shade700,
                                      size: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration('Name', 'Enter your name'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
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
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter your email"),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (!(val.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                                obscureText: false,
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                focusNode: _emailFocus,
                                onFieldSubmitted: (term) {
                                  FocusScope.of(context).requestFocus(_phoneFocus);
                                },
                                onEditingComplete: () {},
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration("Mobile Number", "Enter your mobile number"),
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (!(val.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                                obscureText: false,
                                controller: phoneController,
                                textInputAction: TextInputAction.next,
                                focusNode: _phoneFocus,
                                onFieldSubmitted: (term) {
                                  FocusScope.of(context).requestFocus(_passwordFocus);
                                },
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration("Password*", "Enter your password"),
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
                                textInputAction: TextInputAction.done,
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            Row(
                              children: <Widget>[
                                ListTile(
                                  title: Text(
                                    'Doctor',
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  leading: Radio(
                                    value: "doctor",
                                    groupValue: _registorAs,
                                    activeColor: Color(0xFF6200EE),
                                    onChanged: (String value) {
                                      setState(() {
                                        _registorAs = value;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    'Associate',
                                    style: TextStyle(
                                      color: Theme.of(context).errorColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  leading: Radio(
                                    value: "associate",
                                    groupValue: _registorAs,
                                    activeColor: Color(0xFF6200EE),
                                    onChanged: (String value) {
                                      setState(() {
                                        _registorAs = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15.0),
                            FormField<bool>(
                              builder: (state) {
                                return Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Checkbox(
                                            value: checkboxValue,
                                            onChanged: (value) {
                                              setState(() {
                                                checkboxValue = value;
                                                state.didChange(value);
                                              });
                                            }),
                                        Text(
                                          "I accept all terms and conditions.",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.errorText ?? '',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Theme.of(context).errorColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                              validator: (value) {
                                if (!checkboxValue) {
                                  return 'You need to accept terms and conditions';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Register".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _registerAccount();
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(text: "Already have an account? "),
                                TextSpan(
                                  text: 'Login',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                    },
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                ),
                              ])),
                            ),
                            SizedBox(height: 30.0),
                            Text(
                              "Or create account using social media",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(height: 25.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  child: FaIcon(
                                    FontAwesomeIcons.googlePlus,
                                    size: 35,
                                    color: HexColor("#EC2D2F"),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog("Google Plus", "You tap on GooglePlus social icon.", context);
                                        },
                                      );
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(width: 5, color: HexColor("#40ABF0")),
                                      color: HexColor("#40ABF0"),
                                    ),
                                    child: FaIcon(
                                      FontAwesomeIcons.twitter,
                                      size: 23,
                                      color: HexColor("#FFFFFF"),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog("Twitter", "You tap on Twitter social icon.", context);
                                        },
                                      );
                                    });
                                  },
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                GestureDetector(
                                  child: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 35,
                                    color: HexColor("#3E529C"),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ThemeHelper().alartDialog("Facebook", "You tap on Facebook social icon.", context);
                                        },
                                      );
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _registerAccount() async {
    FocusScope.of(context).unfocus();
    User user;
    UserCredential credential;

    setState(() {
      signingup = true;
    });

    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", error.message, context);
        },
      );
      setState(() {
        signingup = false;
      });
    }
    user = credential.user;

    if (user != null) {
      try {
        await user.updateProfile(displayName: nameController.text);

        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'role': type == "doctor" ? "DOCTOR" : "ASSOCIATE",
          'approved': 'ONPROGRESS',
          'type': null,
          'location': null,
          'aboutme': null,
        }, SetOptions(merge: true));

        if (type == "doctor") {
        } else {}

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
              signingup = false;
            });
          }
        } else {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
          setState(() {
            signingup = false;
          });
        }
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ThemeHelper().alartDialog("Error", error.message, context);
          },
        );
        setState(() {
          signingup = false;
        });
      }
    } else {
      setState(() {
        signingup = false;
      });
    }
  }
}
