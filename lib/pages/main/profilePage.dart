import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/main/doctorAppointments.dart';
import 'package:yismaw/pages/main/editProfile.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfile extends StatefulWidget {
  final String role;
  const UserProfile({Key key, this.role}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                stream: FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots(),
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
                        document['role'] == "DOCTOR" ? '${document['type'] ?? "Doctor"}' : '${document['role'] ?? "Doctor"}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                              alignment: Alignment.topLeft,
                              child: Text(
                                "User Information",
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
                                              subtitle: Text("Address: ${document['location'] ?? "not found"}\nLocality: ${document['locality'] ?? "not found"}\nCity: ${document['city'] ?? "not found"}\nState: ${document['state'] ?? "not found"}\nCountry: ${document['country'] ?? "not found"}"),
                                            ),
                                            ListTile(
                                              leading: Icon(Icons.person),
                                              title: Text("About Me"),
                                              subtitle: Text("${document['aboutme'] ?? "not found"}"),
                                            ),
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
                        height: 20,
                      ),
                      (document['role'] == "DOCTOR")
                          ? Container(
                              margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              child: Text.rich(TextSpan(children: [
                                TextSpan(
                                  text: 'See my appointments',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DoctorAppointmentsScreen(
                                                    doctor: document.id,
                                                    doctorName: document['name'],
                                                  )));
                                    },
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                ),
                              ])),
                            )
                          : SizedBox(
                              height: 2,
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
                            primary: Theme.of(context).primaryColor.withOpacity(0.9),
                            onPrimary: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                  userId: document.id,
                                  doctor: document,
                                  role: widget.role,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Edit Profile',
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
    );
  }
}
