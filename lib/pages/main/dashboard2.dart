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

import 'dart:async';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter/foundation.dart';

import 'package:yismaw/model/cardModel.dart';
import 'package:yismaw/components/carouselSlider.dart';
import 'package:yismaw/firebase/searchList.dart';
import 'package:yismaw/firebase/topRatedList.dart';
import 'package:yismaw/firebase/notificationList.dart';
import 'package:yismaw/pages/exploreList.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => new _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  bool loggingin = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: loggingin,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: HeaderWidget(100, false, Icons.house_rounded),
                ),
                SafeArea(
                  child: Container(
                      /* padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10), */ // This will be the login form
                      child: Column(
                    children: [
                      /* Text(
                            'Hello',
                            style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Signin into your account',
                            style: TextStyle(color: Colors.grey),
                          ), */
                      Container(
                        padding: EdgeInsets.only(left: 23, bottom: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "We care for you",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Carouselslider(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Specialists",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lato(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Container(
                        height: 150,
                        padding: EdgeInsets.only(top: 14),
                        child: ListView.builder(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            //print("images path: ${cards[index].cardImage.toString()}");
                            return Container(
                              margin: EdgeInsets.only(right: 14),
                              height: 150,
                              width: 140,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Color(cards[index].cardBackground), boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[400],
                                  blurRadius: 4.0,
                                  spreadRadius: 0.0,
                                  offset: Offset(3, 3),
                                ),
                              ]
                                  // image: DecorationImage(
                                  //   image: AssetImage(cards[index].cardImage),
                                  //   fit: BoxFit.fill,
                                  // ),
                                  ),
                              // ignore: deprecated_member_use
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ExploreList(
                                              type: cards[index].doctor,
                                            )),
                                  );
                                },
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 29,
                                          child: Icon(
                                            cards[index].cardIcon,
                                            size: 26,
                                            color: Color(cards[index].cardBackground),
                                          )),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      alignment: Alignment.bottomCenter,
                                      child: Text(
                                        cards[index].doctor,
                                        style: GoogleFonts.lato(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ));
  }
}
