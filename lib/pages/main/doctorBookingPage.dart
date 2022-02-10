import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yismaw/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

  final TextEditingController _doctorController = TextEditingController();
  final TextEditingController _hospitalController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();

  bool booking = false;

  @override
  void dispose() {
    _doctorController.dispose();
    _hospitalController.dispose();
    _dateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();
  TimeOfDay currentTime = TimeOfDay.now();
  String timeText = 'Select starting time';
  String timeText2 = 'Select final Time';
  String dateUTC;
  String date_Time;
  String date_Time2;

  Future<void> selectDate(BuildContext context) async {
    showDatePicker(
      context: context,

      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 1)),
      //firstDate: DateTime(2022),
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
        _fromController.text = timeText;
      });
    }
    date_Time = selectedTime.toString().substring(10, 15);
  }

  Future<void> selectTime2(BuildContext context) async {
    TimeOfDay selectedTime2 = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );

    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    String formattedTime = localizations.formatTimeOfDay(selectedTime2, alwaysUse24HourFormat: false);

    if (formattedTime != null) {
      setState(() {
        timeText2 = formattedTime;
        _toController.text = timeText2;
      });
    }
    date_Time2 = selectedTime2.toString().substring(10, 15);
  }

  @override
  void initState() {
    super.initState();
    //selectTime(context);
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
              'Add Availability',
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
                                  'Enter Details',
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
                                controller: _doctorController,
                                focusNode: f1,
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
                                controller: _hospitalController,
                                focusNode: f2,
                                validator: (value) {
                                  if (value.isEmpty) return 'Please Enter Hospital Name';
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
                                  hintText: 'Hospital Name*',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f2.unfocus();
                                  FocusScope.of(context).requestFocus(f3);
                                },
                                textInputAction: TextInputAction.next,
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
                                        hintText: 'Select Starting Time*',
                                        hintStyle: GoogleFonts.lato(
                                          color: Colors.black26,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      controller: _fromController,
                                      validator: (value) {
                                        if (value.isEmpty) return 'Please Enter the starting Time';
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
                                        hintText: 'Select final Time*',
                                        hintStyle: GoogleFonts.lato(
                                          color: Colors.black26,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      controller: _toController,
                                      validator: (value) {
                                        if (value.isEmpty) return 'Please Enter the final Time';
                                        return null;
                                      },
                                      onFieldSubmitted: (String value) {
                                        f5.unfocus();
                                        FocusScope.of(context).requestFocus(f6);
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
                                              selectTime2(context);
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
                              TextFormField(
                                controller: _commentController,
                                focusNode: f6,
                                validator: (value) {
                                  /* if (value.isEmpty) return 'Please Enter Comment'; */
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
                                  hintText: 'Comment',
                                  hintStyle: GoogleFonts.lato(
                                    color: Colors.black26,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                onFieldSubmitted: (String value) {
                                  f6.unfocus();
                                },
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
                                height: 20,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                    text: 'See availability',
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
                ),
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
        'doctor': _doctorController.text,
        'hospital': _hospitalController.text,
        'date': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
        'from': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
        'to': DateTime.parse(dateUTC + ' ' + date_Time2 + ':00'),
        'comment': _commentController.text,
      }, SetOptions(merge: true));

      await FirebaseFirestore.instance.collection('appointments').doc(widget.doctor).collection('all').doc().set({
        'doctor': _doctorController.text,
        'hospital': _hospitalController.text,
        'date': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
        'from': DateTime.parse(dateUTC + ' ' + date_Time + ':00'),
        'to': DateTime.parse(dateUTC + ' ' + date_Time2 + ':00'),
        'comment': _commentController.text,
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
          "Availability is registered.",
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
