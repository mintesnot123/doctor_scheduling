import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/common/theme_helper.dart';
import 'package:flutter/gestures.dart';

class AssociateDetail extends StatefulWidget {
  final String doctor;
  const AssociateDetail({Key key, this.doctor}) : super(key: key);

  @override
  _AssociateDetailState createState() => _AssociateDetailState();
}

class _AssociateDetailState extends State<AssociateDetail> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool approving = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: approving,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Associate Detail',
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
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: HeaderWidget(100, false, Icons.house_rounded),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('users').doc(widget.doctor).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      var document = snapshot.data;
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(width: 1, color: Colors.white),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 20,
                                  offset: const Offset(5, 5),
                                ),
                              ],
                            ),
                            child: (document['approved'] == "APPROVED")
                                ? Stack(
                                    children: <Widget>[
                                      CircleAvatar(
                                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg' /* doctor['image'] */),
                                        radius: 80,
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: FittedBox(
                                            child: Icon(
                                              Icons.check,
                                              color: Colors.blue[900],
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg' /* doctor['image'] */),
                                    radius: 80,
                                  ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${document['name'] ?? "User"}',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            '${document['type'] ?? "Free Subscription"}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Associate Information",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Card(
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      children: <Widget>[
                                        Column(
                                          children: <Widget>[
                                            ...ListTile.divideTiles(
                                              color: Colors.grey,
                                              tiles: [
                                                ListTile(
                                                  leading: Icon(Icons.email),
                                                  title: Text("Email"),
                                                  subtitle: Text("${document['email'] ?? "not found"}"),
                                                ),
                                                ListTile(
                                                  leading: Icon(Icons.phone),
                                                  title: Text("Phone"),
                                                  subtitle: Text("${document['phone'] ?? "not found"}"),
                                                ),
                                                ListTile(
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                  leading: Icon(Icons.my_location),
                                                  title: Text("Location"),
                                                  subtitle: Text("${document['location'] ?? "not found"}"),
                                                ),
                                                /* ListTile(
                                                  leading: Icon(Icons.person),
                                                  title: Text("About Me"),
                                                  subtitle: Text("${document['aboutme'] ?? "not found"}"),
                                                ), */
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                primary: document['approved'] == "APPROVED" ? Colors.red[400].withOpacity(0.9) : Colors.green[400].withOpacity(0.9),
                                onPrimary: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              onPressed: () {
                                document['approved'] == "APPROVED" ? _aproveAccount(false) : _aproveAccount(true);
                              },
                              child: Text(
                                document['approved'] == "APPROVED" ? 'Block Account' : 'Approve Account',
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _aproveAccount(bool approve) async {
    setState(() {
      approving = true;
    });

    try {
      await _firestore.collection('users').doc(widget.doctor).set({
        'approved': approve ? 'APPROVED' : 'REJECTED',
      }, SetOptions(merge: true));
      setState(() {
        approving = false;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", error.message, context);
        },
      );
      setState(() {
        approving = false;
      });
    }
  }
}
