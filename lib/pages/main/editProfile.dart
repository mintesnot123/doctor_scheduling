import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/pages/main/profilePage.dart';
import 'package:flutter/gestures.dart';

class EditProfileScreen extends StatefulWidget {
  final doctor;
  final String userId;
  final String role;

  const EditProfileScreen({Key key, this.doctor, this.userId, this.role}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();
  FocusNode f7 = FocusNode();
  FocusNode f8 = FocusNode();

  bool updating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _specialityController.dispose();
    _addressController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.doctor['name'] ?? '';
    _phoneController.text = widget.doctor['phone'] ?? '';
    _specialityController.text = widget.doctor['type'] ?? '';
    _addressController.text = widget.doctor['location'] ?? '';
    _localityController.text = widget.doctor['locality'] ?? '';
    _cityController.text = widget.doctor['city'] ?? '';
    _stateController.text = widget.doctor['state'] ?? '';
    _countryController.text = widget.doctor['country'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: updating,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Edit Profile',
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
            child: Column(children: [
              Container(
                height: 100,
                child: HeaderWidget(100, false, Icons.house_rounded),
              ),
              SafeArea(
                child: Container(
                  child: Column(
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
                        child: (widget.doctor['approved'] == "APPROVED")
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
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.only(top: 0),
                          child: Column(
                            children: [
                              /* Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Enter Patient Details',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                  ),
                                ),
                              ), */
                              SizedBox(
                                height: 30,
                              ),
                              TextFormField(
                                controller: _nameController,
                                focusNode: f1,
                                validator: (value) {
                                  if (value.isEmpty) return 'Please Enter Your Name';
                                  return null;
                                },
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'Your Name*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f1.unfocus();
                                  FocusScope.of(context).requestFocus(f2);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.phone,
                                focusNode: f2,
                                controller: _phoneController,
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'Phone Number',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Phone number';
                                  } else if (value.length < 10) {
                                    return 'Please Enter correct Phone number';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (String value) {
                                  f2.unfocus();
                                  FocusScope.of(context).requestFocus(f3);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                controller: _specialityController,
                                focusNode: f3,
                                validator: (value) {
                                  //if (value.isEmpty) return 'Please Enter Your Speciality';
                                  return null;
                                },
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'Speciality*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f3.unfocus();
                                  FocusScope.of(context).requestFocus(f4);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: f4,
                                controller: _addressController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'Address',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f4.unfocus();
                                  FocusScope.of(context).requestFocus(f5);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: f5,
                                controller: _localityController,
                                validator: (value) {
                                  //if (value.isEmpty) return 'Please enter Your Locality';
                                  return null;
                                },
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'Locality*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f5.unfocus();
                                  FocusScope.of(context).requestFocus(f6);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: f6,
                                controller: _cityController,
                                validator: (value) {
                                  //if (value.isEmpty) return 'Please enter Your City';
                                  return null;
                                },
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'City*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f6.unfocus();
                                  FocusScope.of(context).requestFocus(f7);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: f7,
                                controller: _stateController,
                                validator: (value) {
                                  //if (value.isEmpty) return 'Please enter Your State';
                                  return null;
                                },
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'State*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f7.unfocus();
                                  FocusScope.of(context).requestFocus(f8);
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                focusNode: f8,
                                controller: _countryController,
                                validator: (value) {
                                  //if (value.isEmpty) return 'Please enter Your Country';
                                  return null;
                                },
                                style: GoogleFonts.lato(fontSize: 18),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[350],
                                  hintText: 'Country*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f8.unfocus();
                                },
                                textInputAction: TextInputAction.next,
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 2,
                                    primary: Theme.of(context).primaryColor,
                                    onPrimary: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _editProfile();
                                    }
                                  },
                                  child: Text(
                                    "Submit",
                                    style: GoogleFonts.lato(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  Future<void> _editProfile() async {
    setState(() {
      updating = true;
    });

    try {
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'type': _specialityController.text,
        'location': _addressController.text,
        'locality': _localityController.text,
        'city': _cityController.text,
        'state': _stateController.text,
        'country': _countryController.text,
      });

      Widget okButton = TextButton(
        child: Text(
          "OK",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfile(
                role: widget.role,
              ),
            ),
          );
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text(
          "Done!",
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Profile is updated.",
          style: GoogleFonts.lato(),
        ),
        actions: [
          okButton,
        ],
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
      setState(() {
        updating = false;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", error.message, context);
        },
      );
      setState(() {
        updating = false;
      });
    }
  }
}
