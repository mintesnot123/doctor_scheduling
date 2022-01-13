import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:typicons_flutter/typicons_flutter.dart';
import 'package:quick_actions/quick_actions.dart';

import 'package:yismaw/firebase/searchList.dart';
import 'package:yismaw/pages/adminHome.dart';
import 'package:yismaw/pages/doctorList.dart';
import 'package:yismaw/pages/associateList.dart';
import 'package:yismaw/pages/userProfile.dart';

class Home extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
            child: Text("Something went wrong"),
          ));
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Scaffold(
              body: Center(
            child: Text("Document does not exist"),
          ));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
          return checkRole(data);
          //return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Scaffold(body: LinearProgressIndicator());
      },
      /* builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return checkRole(snapshot.data);
          }
          return LinearProgressIndicator();
        }, */
    );
  }

  Center checkRole(Map<String, dynamic> snapshot) {
    if (snapshot['role'] == 'ADMIN') {
      return MainPage();
    } else {
      return userPage(snapshot);
    }
  }

  Center adminPage(Map<String, dynamic> snapshot) {
    return Scaffold(body: Center(child: Text('${snapshot['role']} ${snapshot['name']}')));
  }

  Center userPage(Map<String, dynamic> snapshot) {
    return Scaffold(body: Center(child: Text('${snapshot['name']}')));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  List<Widget> _pages = [
    HomePage(),
    DoctorsList(),
    HomePage(),
    //DoctorsList(),
    //Center(child: Text('New Appointment')),
    //MyAppointments(),
    UserProfile(),
  ];

  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  _navigate(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  String shortcut = "no action set";

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        key: _scaffoldKey,
        body: _pages[_selectedIndex],
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Doctors"),
                leading: Icon(Icons.home),
                selected: _selectedIndex == 1,
                onTap: () {
                  /* _openPage(0); */
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
                selected: _selectedIndex == 2,
                onTap: () {
                  /* _openPage(0); */
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                curve: Curves.easeOutExpo,
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                haptic: true,
                tabBorderRadius: 20,
                gap: 5,
                activeColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: Colors.blue.withOpacity(0.7),
                textStyle: GoogleFonts.lato(
                  color: Colors.white,
                ),
                tabs: [
                  GButton(
                    iconSize: _selectedIndex != 0 ? 28 : 25,
                    icon: _selectedIndex == 0 ? FlutterIcons.home_fou : FlutterIcons.home_variant_outline_mco,
                    text: 'Home',
                  ),
                  GButton(
                    icon: FlutterIcons.person_mdi,
                    text: 'Doctors',
                  ),
                  GButton(
                    iconSize: _selectedIndex != 2 ? 20 : 15,
                    icon: /* _selectedIndex == 2 ? */ FlutterIcons.clinic_medical_faw5s /* : Typicons.calendar_outline */,
                    text: 'Schedule',
                  ),
                  GButton(
                    iconSize: 29,
                    icon: _selectedIndex == 3 ? Typicons.user : Typicons.user_outline,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: _onItemTapped,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
