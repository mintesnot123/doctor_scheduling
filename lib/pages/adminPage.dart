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

import 'package:yismaw/common/theme_helper.dart';

import 'package:yismaw/firebase/searchList.dart';
import 'package:yismaw/pages/adminHome.dart';
import 'package:yismaw/pages/doctorList.dart';
import 'package:yismaw/pages/userProfile.dart';
import 'package:yismaw/pages/auth/splash.dart';
import 'package:yismaw/pages/auth/emailVerificationPage.dart';
import 'package:yismaw/pages/main/doctorHome.dart';
import 'package:yismaw/pages/main/adminHome.dart';
import 'package:yismaw/pages/main/associateHome.dart';

class Home extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser(context) async {
    user = _auth.currentUser;
    if (user == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SplashPage()),
      );
    } else if (!user.emailVerified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailVerificationPage(user: user)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUser(context);

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
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget checkRole(Map<String, dynamic> snapshot) {
    if (snapshot['role'] == 'ADMIN') {
      return AdminHomePage();
    } else if (snapshot['role'] == 'DOCTOR') {
      return DoctorHomePage();
    } else if (snapshot['role'] == 'ASSOCIATE') {
      return AssociateHomePage();
    } else {
      return Scaffold(
          body: Center(
        child: Text("Something went wrong"),
      ));
    }
  }
}
