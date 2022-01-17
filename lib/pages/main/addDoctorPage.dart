import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yismaw/common/theme_helper.dart';

import 'package:flutter/gestures.dart';
import 'package:yismaw/pages/main/addUserPage.dart';

class AddDoctorPage extends StatefulWidget {
  const AddDoctorPage({
    Key key,
  }) : super(key: key);
  @override
  _AddDoctorPageState createState() => _AddDoctorPageState();
}

class _AddDoctorPageState extends State<AddDoctorPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Add Doctor',
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
            leading: IconButton(
                splashRadius: 20,
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: AddUserPage(),
        ));
  }
}
