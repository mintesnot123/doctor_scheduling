import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:yismaw/pages/myAppointments.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/pages/main/doctorAppointments.dart';
import 'package:flutter/gestures.dart';

class DoctorBookingScreen extends StatefulWidget {
  final String doctor;
  final String doctorName;

  const DoctorBookingScreen({Key key, this.doctor, this.doctorName}) : super(key: key);
  @override
  _DoctorBookingScreenState createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();

  bool booking = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _doctorController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select Time';
  String dateUTC;
  String date_Time;

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
    ).then(
      (date) {
        setState(
          () {
            selectedDate = date;
            String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
            _dateController.text = formattedDate;
            dateUTC = DateFormat('yyyy-MM-dd').format(selectedDate);
          },
        );
      },
    );
  }

  Future<void> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime, alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        timeText = formattedTime;
        _timeController.text = timeText;
      });
    }
    date_Time = selectedTime.toString().substring(10, 15);
  }

  @override
  void initState() {
    super.initState();
    selectTime(context);
    _doctorController.text = widget.doctorName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: booking,
        child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(
              'Appointment booking',
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
              ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    child: Image(
                      image: AssetImage('assets/images/appointment.jpg'),
                      height: 250,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.only(top: 0),
                      child: Column(
                        children: [
                          Container(
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
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          TextFormField(
                            controller: _nameController,
                            focusNode: f1,
                            validator: (value) {
                              if (value.isEmpty) return 'Please Enter Patient Name';
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
                              hintText: 'Patient Name*',
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
                              hintText: 'Mobile*',
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
                            focusNode: f3,
                            controller: _descriptionController,
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
                              hintText: 'Description',
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
                            controller: _doctorController,
                            validator: (value) {
                              if (value.isEmpty) return 'Please enter Doctor name';
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
                              hintText: 'Doctor Name*',
                              hintStyle: GoogleFonts.lato(
                                color: Colors.black26,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextFormField(
                                  focusNode: f4,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[350],
                                    hintText: 'Select Date*',
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.black26,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  controller: _dateController,
                                  validator: (value) {
                                    if (value.isEmpty) return 'Please Enter the Date';
                                    return null;
                                  },
                                  onFieldSubmitted: (String value) {
                                    f4.unfocus();
                                    FocusScope.of(context).requestFocus(f5);
                                  },
                                  textInputAction: TextInputAction.next,
                                  style: GoogleFonts.lato(fontSize: 18),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Theme.of(context).primaryColor,
                                      child: InkWell(
                                        // inkwell color
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.date_range_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          selectDate(context);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextFormField(
                                  focusNode: f5,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                      left: 20,
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[350],
                                    hintText: 'Select Time*',
                                    hintStyle: GoogleFonts.lato(
                                      color: Colors.black26,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  controller: _timeController,
                                  validator: (value) {
                                    if (value.isEmpty) return 'Please Enter the Time';
                                    return null;
                                  },
                                  onFieldSubmitted: (String value) {
                                    f5.unfocus();
                                  },
                                  textInputAction: TextInputAction.next,
                                  style: GoogleFonts.lato(fontSize: 18),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: ClipOval(
                                    child: Material(
                                      color: Theme.of(context).primaryColor,
                                      child: InkWell(
                                        // inkwell color
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            Icons.timer_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          selectTime(context);
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
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
                                  _createAppointment();
                                }
                              },
                              child: Text(
                                "Book Appointment",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                text: 'See doctor appointments',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DoctorAppointmentsScreen(
                                                  doctor: widget.doctor,
                                                  doctorName: widget.doctorName,
                                                )));
                                  },
                                style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                              ),
                            ])),
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
            ]),
          ),
        ));
  }

  Future<void> _createAppointment() async {
    setState(() {
      booking = true;
    });

    try {
      await FirebaseFirestore.instance.collection('appointments').doc(widget.doctor).collection('pending').doc().set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'description': _descriptionController.text,
        'doctor': _doctorController.text,
        'date': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection('appointments').doc(widget.doctor).collection('all').doc().set({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'description': _descriptionController.text,
        'doctor': _doctorController.text,
        'date': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
      }, SetOptions(merge: true));
      Widget okButton = TextButton(
        child: Text(
          "OK",
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorAppointmentsScreen(
                doctor: widget.doctor,
                doctorName: widget.doctorName,
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
          "Appointment is registered.",
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
        booking = false;
      });
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", error.message, context);
        },
      );
      setState(() {
        booking = false;
      });
    }
  }
}
