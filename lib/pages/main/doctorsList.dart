import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/main/addDoctorPage.dart';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:yismaw/firebase/searchList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yismaw/pages/main/doctorDetail.dart';
import 'package:yismaw/pages/main/searchResultPage.dart';

class DoctorsListPage extends StatefulWidget {
  final String role;
  const DoctorsListPage({Key key, this.role}) : super(key: key);
  @override
  _DoctorsListPageState createState() => new _DoctorsListPageState();
}

class _DoctorsListPageState extends State<DoctorsListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _doctorName = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future getData() {
    print('infds sdj')
    FirebaseFirestore.instance.collection('doctors').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["first_name"]);
      });
    });
    //FirebaseFirestore.instance.collection('doctors').orderBy('name').snapshots()
  }

  @override
  void initState() {
    super.initState();
    _getUser();
    _doctorName = new TextEditingController();
    getData();
  }

  @override
  void dispose() {
    _doctorName.dispose();
    super.dispose();
  }

  bool loggingin = false;
  var filters = [
    'name',
    'locality',
    'city',
    'state',
    'country',
    'speciality'
  ];
  String selectedFilter = 'name';
  void setSelectedFilter(value) {
    selectedFilter = value;
  }

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
                                              builder: (context) => SearchResultPage(
                                                searchKey: _doctorName.text,
                                                filter: selectedFilter,
                                                type: "DOCTOR",
                                                role: "ADMIN",
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
                                            builder: (context) => SearchResultPage(
                                              searchKey: value,
                                              filter: selectedFilter,
                                              type: "DOCTOR",
                                              role: "ADMIN",
                                            ),
                                          ),
                                        );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 45.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            itemCount: filters.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0),
                                  child: Chip(
                                    labelPadding: EdgeInsets.all(2.0),
                                    label: Text(
                                      filters[index],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: selectedFilter == filters[index] ? Colors.blue[600] : Colors.blue[0],
                                    elevation: 6.0,
                                    shadowColor: Colors.grey[60],
                                    padding: EdgeInsets.all(8.0),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedFilter = filters[index];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "All doctors",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').where("role", isEqualTo: "DOCTOR").orderBy('name').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            return snapshot.data.size == 0
                                ? Center(
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'No Doctor found!',
                                            style: GoogleFonts.lato(
                                              color: Colors.blue[800],
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Image(
                                            image: AssetImage('assets/images/error-404.jpg'),
                                            height: 250,
                                            width: 250,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Scrollbar(
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.size,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot doctor = snapshot.data.docs[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 0.0),
                                          child: Card(
                                            color: Colors.blue[50],
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.only(left: 10, right: 10, top: 0),
                                              width: MediaQuery.of(context).size.width,
                                              height: MediaQuery.of(context).size.height / 9,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => DoctorDetail(doctor: doctor.id, role: widget.role),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    (doctor['approved'] == "APPROVED")
                                                        ? Flexible(
                                                            flex: 1,
                                                            child: Stack(
                                                              children: <Widget>[
                                                                CircleAvatar(
                                                                  backgroundImage: AssetImage('assets/images/doctor_profile.jpg'), //NetworkImage('https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg' /* doctor['image'] */),
                                                                  radius: 30,
                                                                ),
                                                                Positioned(
                                                                  bottom: 0,
                                                                  right: 0,
                                                                  child: Container(
                                                                    width: 15.0,
                                                                    height: 15.0,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      shape: BoxShape.circle,
                                                                    ),
                                                                    child: FittedBox(
                                                                      child: Icon(
                                                                        Icons.check,
                                                                        color: Colors.red[900],
                                                                        size: 24,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )
                                                        : CircleAvatar(
                                                            backgroundImage: AssetImage('assets/images/doctor_profile.jpg'), //NetworkImage('https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg' /* doctor['image'] */),
                                                            radius: 30,
                                                          ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          'Dr. ${doctor['name'] ?? 'User'}'.length > 18 ? 'Dr. ${doctor['name'] ?? 'User'}'.substring(0, 18) + "..." : 'Dr. ${doctor['name'] ?? 'User'}',
                                                          style: GoogleFonts.lato(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 17,
                                                            color: Colors.black87,
                                                          ),
                                                        ),
                                                        Text(
                                                          '${doctor['type'] ?? "Specialist Doctor"}'.length > 30 ? '${doctor['type'] ?? "Specialist Doctor"}'.substring(0, 27) + "..." : '${doctor['type'] ?? "Specialist Doctor"}',
                                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    /* Expanded(
                                                      child: Container(
                                                        alignment: Alignment.centerRight,
                                                        child: Row(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          mainAxisAlignment: MainAxisAlignment.end,
                                                          children: [
                                                            Icon(
                                                              Typicons.star_full_outline,
                                                              size: 20,
                                                              color: Colors.indigo[400],
                                                            ),
                                                            SizedBox(
                                                              width: 3,
                                                            ),
                                                            Text(
                                                              doctor['rating'].toString(),
                                                              style: GoogleFonts.lato(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 15,
                                                                color: Colors.indigo,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ), */
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: (widget.role == 'admin' || widget.role == 'associate')
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddDoctorPage(),
                      ),
                    );
                  },
                  backgroundColor: Colors.blue.withOpacity(0.7),
                  child: const Icon(Icons.add),
                )
              : null,
        ));
  }
}
