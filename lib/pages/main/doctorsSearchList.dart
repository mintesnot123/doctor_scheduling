import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yismaw/pages/doctorProfile.dart';
import 'package:typicons_flutter/typicons_flutter.dart';

class SearchList extends StatefulWidget {
  final String searchKey;
  const SearchList({Key key, this.searchKey}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Search Doctors',
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
        /* actions: [
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
        ], */
      ),
      /* appBar: AppBar(
        backgroundColor: Colors.blue.withOpacity(0.7),
        leading: IconButton(
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Search Doctors',
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ), */
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('doctors').orderBy('name').startAt([
            /* 'Dr. ' +  */ widget.searchKey
          ]).endAt([
            /* 'Dr. ' +  */ widget.searchKey + '\uf8ff'
          ]).snapshots(),
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
                                      builder: (context) => DoctorProfile(
                                        doctor: doctor.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(doctor['image']),
                                      //backgroundColor: Colors.blue,
                                      radius: 25,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doctor['name'],
                                          style: GoogleFonts.lato(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          doctor['type'],
                                          style: GoogleFonts.lato(fontSize: 16, color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
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
                                    ),
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
      ),
    );
  }
}
