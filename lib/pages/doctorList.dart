import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:yismaw/firebase/searchList.dart';
import 'package:yismaw/firebase/notificationList.dart';

class DoctorsList extends StatefulWidget {
  @override
  _DoctorsListState createState() => _DoctorsListState();
}

class _DoctorsListState extends State<DoctorsList> {
  TextEditingController _textController = new TextEditingController();
  String search;
  var _length = 0;

  @override
  void initState() {
    super.initState();
    search = _textController.text;
    _length = search.length;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Container()
        ],
        backgroundColor: Colors.blue.withOpacity(0.7),
        /* elevation: 0, */
        title: Container(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Find Doctors",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                width: 55,
              ),
              IconButton(
                splashRadius: 20,
                icon: Icon(Icons.notifications_active),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (contex) => NotificationList()));
                },
              ),
            ],
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      /* appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Find Doctors'),
        actions: <Widget>[
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: TextFormField(
                controller: _textController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Search Doctor',
                  hintStyle: GoogleFonts.lato(
                    color: Colors.black26,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  prefixIcon: Icon(
                    FlutterIcons.search1_ant,
                    size: 20,
                  ),
                  prefixStyle: TextStyle(
                    color: Colors.grey[300],
                  ),
                  suffixIcon: _textController.text.length != 0
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              _textController.clear();
                              _length = search.length;
                            });
                          },
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                          ),
                        )
                      : SizedBox(),
                ),
                // onFieldSubmitted: (String _searchKey) {
                //   setState(
                //     () {
                //       print('>>>' + _searchKey);
                //       search = _searchKey;
                //     },
                //   );
                // },
                onChanged: (String _searchKey) {
                  setState(
                    () {
                      print('>>>' + _searchKey);
                      search = _searchKey;
                      _length = search.length;
                    },
                  );
                },
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textInputAction: TextInputAction.search,
                autofocus: false,
              ),
            ),
          )
        ],
      ), */
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () {},
                      child: const Text('Add Doctor'),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
                TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    hintText: 'Search Doctor',
                    hintStyle: GoogleFonts.lato(
                      color: Colors.black26,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                    prefixIcon: Icon(
                      FlutterIcons.search1_ant,
                      size: 20,
                    ),
                    prefixStyle: TextStyle(
                      color: Colors.grey[300],
                    ),
                    suffixIcon: _textController.text.length != 0
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _textController.clear();
                                _length = search.length;
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 20,
                            ),
                          )
                        : SizedBox(),
                  ),
                  // onFieldSubmitted: (String _searchKey) {
                  //   setState(
                  //     () {
                  //       print('>>>' + _searchKey);
                  //       search = _searchKey;
                  //     },
                  //   );
                  // },
                  onChanged: (String _searchKey) {
                    setState(
                      () {
                        print('>>>' + _searchKey);
                        search = _searchKey;
                        _length = search.length;
                      },
                    );
                  },
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textInputAction: TextInputAction.search,
                  autofocus: false,
                ),
                (_length == 0
                    ? SearchList(
                        searchKey: '',
                      ))/* Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    _length = 1;
                                  });
                                },
                                child: Text(
                                  'Show All',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Image(image: AssetImage('assets/images/search-bg.png')),
                            ],
                          ),
                        ),
                      ) */
                    : SearchList(
                        searchKey: search,
                      ))
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        backgroundColor: Colors.blue.withOpacity(0.7),
        child: const Icon(Icons.add),
      ),
    );
  }
}
