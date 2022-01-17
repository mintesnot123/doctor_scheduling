import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';

class AddUserPage extends StatefulWidget {
  final type;
  const AddUserPage({
    Key key,
    this.type,
  }) : super(key: key);
  @override
  _AddUserPageState createState() => new _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  bool signingup = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String defaultPassword = "123456789";

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: signingup,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: HeaderWidget(100, false, Icons.house_rounded),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 25, 25, 10),
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
                                decoration: ThemeHelper().textInputDecoration('Name', 'Enter doctor name'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
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
                                decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter doctor email"),
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
                                decoration: ThemeHelper().textInputDecoration("Mobile Number", "Enter doctor mobile number"),
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
                                    "Registor".toUpperCase(),
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
    User user;
    UserCredential credential;

    setState(() {
      signingup = true;
    });
    FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);

    try {
      credential = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: emailController.text, password: defaultPassword);
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
    await app.delete();
    if (user != null) {
      try {
        await user.updateProfile(displayName: nameController.text);

        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'role': widget.type == "doctor" ? "DOCTOR" : "ASSOCIATE",
          'approved': 'ONPROGRESS',
          'type': null,
          'location': null,
          'aboutme': null,
        }, SetOptions(merge: true));

        if (widget.type == "doctor") {
        } else {}
        // todo back to doctors list
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
        setState(() {
          signingup = false;
        });
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
