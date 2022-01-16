import 'package:yismaw/widgets/header_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:yismaw/pages/main/appointmentsList.dart';

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
              'Appointments',
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
              SizedBox(
                height: 30,
              ),
              AppointmentList(
                doctor: widget.doctor,
              ),
            ]),
          ),
        ));
  }
}
