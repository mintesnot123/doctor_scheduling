import 'package:flutter/material.dart';
import 'package:yismaw/pages/main/addUserPage.dart';

class AddAssociatePage extends StatefulWidget {
  const AddAssociatePage({
    Key key,
  }) : super(key: key);
  @override
  _AddAssociatePageState createState() => _AddAssociatePageState();
}

class _AddAssociatePageState extends State<AddAssociatePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Add Associate',
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
      body: AddUserPage(
        type: "associate",
      ),
    );
  }
}
