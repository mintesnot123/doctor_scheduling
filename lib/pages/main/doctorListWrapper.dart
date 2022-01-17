import 'package:flutter/material.dart';
import 'package:yismaw/pages/main/doctorsList.dart';

class DoctorListWrapperPage extends StatefulWidget {
  final String role;
  const DoctorListWrapperPage({Key key, this.role}) : super(key: key);
  @override
  _DoctorListWrapperPageState createState() => _DoctorListWrapperPageState();
}

class _DoctorListWrapperPageState extends State<DoctorListWrapperPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Doctors',
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
      body: DoctorsListPage(
        role: widget.role,
      ),
    );
  }
}
