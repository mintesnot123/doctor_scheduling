import 'dart:async';
import 'dart:ui';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:yismaw/model/cardModel.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/components/carouselSlider.dart';
import 'package:yismaw/pages/main/doctorsSearchList.dart';
import 'package:yismaw/pages/main/doctorsListByCategory.dart';

class DashboardPage extends StatefulWidget {
  final String role;
  const DashboardPage({Key key, this.role}) : super(key: key);
  @override
  _DashboardPageState createState() => new _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _doctorName = new TextEditingController();
  }

  @override
  void dispose() {
    _doctorName.dispose();
    super.dispose();
  }

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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(
                            "Hello " + (user.displayName ?? "User"),
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 20, bottom: 25),
                          child: Text(
                            "Let's Find Your\nDoctor",
                            style: GoogleFonts.lato(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 25),
                          child: TextFormField(
                            textInputAction: TextInputAction.search,
                            controller: _doctorName,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Search doctor',
                              hintStyle: GoogleFonts.lato(
                                color: Colors.black26,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                              suffixIcon: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue[900].withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: IconButton(
                                  iconSize: 20,
                                  splashRadius: 20,
                                  color: Colors.white,
                                  icon: Icon(FlutterIcons.search1_ant),
                                  onPressed: () {
                                    _doctorName.text.length == 0
                                        ? Container()
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SearchList(
                                                searchKey: _doctorName.text,
                                                role: widget.role,
                                              ),
                                            ),
                                          );
                                  },
                                ),
                              ),
                            ),
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                            onFieldSubmitted: (String value) {
                              setState(
                                () {
                                  value.length == 0
                                      ? Container()
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SearchList(
                                              searchKey: value,
                                              role: widget.role,
                                            ),
                                          ),
                                        );
                                },
                              );
                            },
                          ),
                        ),
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
                          child: Carouselslider(
                            role: widget.role,
                          ),
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
                                          builder: (context) => DoctorsListByCategory(
                                                searchKey: cards[index].doctor,
                                                role: widget.role,
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
