import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:yismaw/pages/main/doctorDetail.dart';

class SearchResultPage extends StatefulWidget {
  final String searchKey;
  final String filter;
  final String role;
  final String type;
  const SearchResultPage({Key key, this.searchKey, this.filter, this.role, this.type}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  void load() {
    FirebaseFirestore.instance
        .collection('users')
        .where("role", isEqualTo: "DOCTOR" /* widget.type */)
        .where('name' /* widget.filter */, isEqualTo: "A" /* widget.searchKey */)
        . /* orderBy('name'). */ /* snapshots() */ get()
        .then((value) => {
              print("User Added")
            })
        .catchError((error) => {
              print("Failed to add user: $error")
            });
  }

  @override
  void initState() {
    super.initState();
    //selectTime(context);
    load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Search Result',
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
            SizedBox(
              height: 30,
            ),
            SafeArea(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('users').where("role", isEqualTo: "DOCTOR" /* widget.type */). /* where('name' */ /* widget.filter */ /* , isEqualTo: "A" */ /* widget.searchKey */ /* ). */ /* orderBy('name'). */ snapshots(),
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
                                  'No ${widget.searchKey} ${widget.type == "DOCTOR" ? "Doctor" : "Associate"} found!',
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
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.only(left: 20),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "All ${widget.searchKey} ${widget.type == "DOCTOR" ? "Doctors" : "Associates"}",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lato(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              ListView.builder(
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
                                                builder: (context) => DoctorDetail(
                                                  doctor: doctor.id,
                                                  role: widget.role,
                                                ),
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
                                                            backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg' /* doctor['image'] */),
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
                                                      backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg' /* doctor['image'] */),
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
