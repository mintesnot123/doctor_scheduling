import 'package:yismaw/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yismaw/pages/main/appointmentsList.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yismaw/pages/main/doctorBookingPage.dart';

class DoctorAppointmentsScreen extends StatefulWidget {
  final String doctor;
  final String doctorName;

  const DoctorAppointmentsScreen({Key key, this.doctor, this.doctorName}) : super(key: key);
  @override
  _DoctorAppointmentsScreenState createState() => _DoctorAppointmentsScreenState();
}

class _DoctorAppointmentsScreenState extends State<DoctorAppointmentsScreen> {
  bool booking = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: booking,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Availabilities',
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
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, bottom: 25),
                child: Text(
                  "Dr. ${widget.doctorName ?? "User"}",
                  style: GoogleFonts.lato(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Availabilities",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(color: Colors.blue[800], fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              AppointmentList(
                doctor: widget.doctor,
              ),
              SizedBox(
                height: 15,
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
                        builder: (context) => DoctorBookingScreen(
                          doctor: widget.doctor,
                          doctorName: widget.doctorName,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Add Availability',
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ));
  }
}
