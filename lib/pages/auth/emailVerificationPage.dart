import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yismaw/common/theme_helper.dart';

import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/auth/login.dart';

class EmailVerificationPage extends StatefulWidget {
  final user;
  const EmailVerificationPage({Key key, this.user}) : super(key: key);

  @override
  _EmailVerificationPageState createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: _headerHeight,
                child: HeaderWidget(_headerHeight, true, Icons.privacy_tip_outlined),
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
                              'Email Verification',
                              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "We have send email verification link to your email. please ",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                  TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => LoginPage()),
                                        );
                                      },
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).accentColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " to your account.",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "If you didn't receive an email! ",
                              style: TextStyle(
                                color: Colors.black38,
                              ),
                            ),
                            TextSpan(
                              text: 'Resend',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  try {
                                    await widget.user.sendEmailVerification();
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog("Successful", "Verification code resend successful.", context);
                                      },
                                    );
                                  } catch (error) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ThemeHelper().alartDialog("Error", error.message, context);
                                      },
                                    );
                                  }
                                },
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
