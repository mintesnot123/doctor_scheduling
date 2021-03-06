import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yismaw/pages/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yismaw/pages/main/dashboard.dart';
import 'package:yismaw/pages/main/profilePage.dart';
import 'package:yismaw/pages/main/myAppointments.dart';

class DoctorHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _DoctorHomePageState();
  }
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  int _selectedIndex = 0;
  List<Widget> _pages = [
    /* DashboardPage(
      role: 'doctor',
    ), */
    UserProfile(),
    MyAppointmentsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future _signOut() async {
    await _auth.signOut();
  }

  List<String> pageTitle = [
    /* 'Dashboard', */
    "My Profile",
    'My Availabilities',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitle[_selectedIndex],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: <Color>[
            Theme.of(context).primaryColor,
            Theme.of(context).accentColor,
          ])),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(
              top: 16,
              right: 16,
            ),
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: Text(
                      '5',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: [
            0.0,
            1.0
          ], colors: [
            Theme.of(context).primaryColor.withOpacity(0.2),
            Theme.of(context).accentColor.withOpacity(0.5),
          ])),
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [
                      0.0,
                      1.0
                    ],
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).accentColor,
                    ],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Doctors Management",
                    style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              /* ListTile(
                leading: Icon(
                  Icons.dashboard,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Dashboard',
                  style: TextStyle(fontSize: 17, color: Theme.of(context).accentColor),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ), */
              ListTile(
                leading: Icon(
                  Icons.person,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'My Profile',
                  style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                ),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.list, size: _drawerIconSize, color: Theme.of(context).accentColor),
                title: Text(
                  'My Availabilities',
                  style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                ),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).accentColor,
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(fontSize: _drawerFontSize, color: Theme.of(context).accentColor),
                ),
                onTap: () {
                  _signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
