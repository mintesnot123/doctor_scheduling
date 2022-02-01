import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:yismaw/common/theme_helper.dart';
import 'package:yismaw/widgets/header_widget.dart';

class AddUserPage extends StatefulWidget {
  final type;
  const AddUserPage({
    Key key,
    this.type,
  }) : super(key: key);
  @override
  _AddUserPageState createState() => new _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = new TextEditingController();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController phoneController = new TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  bool signingup = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  var userDatas = [
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "VAIBHAV   SHUKLA",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "ZEBA SIDDIQUI",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "ASISH KUMAR GUPTA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "M S SIDDQUI",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "VIPIN   KUMAR",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "ABHISHEK KUMAR PANDEY",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "AFROZ   AHMED",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "ROBIN   SINGH",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "DANISH JAMEEL KHAN",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "MOHAMAD   TABISH",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "PRIYANK   SAHOO",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "NANDAN KUMAR MISHRA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "SHARIB   SHAMIM",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "SOVIK   YADAV",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "DUBAGGA",
      "Lucknow",
      "IMRAN SHAKEEL KHAN",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "MANEESH KUMAR SINGH",
      "NEUROLOGIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SUSHIL   GATTANI",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SAMIR   GUPTA",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ABHAY   KRISHNA",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ANIL   KHANNA",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "DIVAKAR   DALELA",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SANTOSH   KUMAR",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "VISHWAJEET   SINGH",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "APUL   GOEL",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SATYANARAYAN   SANKHWAR",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "Y K ARORA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "KAMAL   MEHRA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ADITYA KUMAR SHARMA",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "M S CHABRA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "A K AWASTHI",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "RAHUL JANAK SINHA",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ASHISH KUMAR SINGH",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ANAND   KUMAR",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "DARSHAN   BAJAJ",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "BHUPENDRA PAL SINGH",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ZULFIQAR   GHOURI",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "LALIT   SHARMA",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "AJAY KUMAR VERMA",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "DURGESH KR SRIVASTAV",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "PARESH   SHUKLA",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "MADHUKAR   TRIVEDI",
      "NEUROLOGIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SIDDHARTH   SINGH",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ANKUR   SAXENA",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "GAURAV   TRIVEDI",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "JITENDRA PRATAP SINGH",
      "NEPHROLOGIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SUCHARITA   ANAND",
      "NEUROLOGIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SHULKSHANA   GOUTAM",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ORINDER   SINGH",
      "GENERAL PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "RAJESH   KUMAR",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SHISHIR   PATEL",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SANJAY   SINGHAL",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "H S GUPTA",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "R C SINGH",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ABHISEK KUMAR KAAR",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "KRISHNA   KANT",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SUDHANSU   PANDEY",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "J C   GUPTA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "TONY   J",
      "ENDOCRINOLOGIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "CHETANA   SAMSERI",
      "GENERAL PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "MANOJ   KUMAR",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "RICHA   TYAGI",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "VIGNESH KUMAR",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "AMIT RAJ SHARMAA",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SHIV KUMAR",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "MOHD TARIQ",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "AMIT   KUNDU",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SAQIB   MEHDI",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "BISWANU SUNDAR BISWAL",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "RISHI   DWIVEDI",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ASHISH   JAISWAL",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "USMAN   MUSA",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "C S RAWAT",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "YASH   JAGDHANI",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ANKIT D PATEL",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SAPNA   DIXIT",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "PAVAN KUMAR S K",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "AKASH   BANSAL",
      "URO SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "RAJEEV KUMAR AGARWAL",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SANDEEP   GUPTA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "NAVEEN   KUMAR",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "MADHURESH   KUMAR",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "ABHISHEK   SINGH",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "VINEET   AGARWAL",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "YOGESH   SETHI",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "S   MUNSHI",
      "GENERAL SURGEON"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "DINESH   KUMAR",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SURYA KANT TRIPATHY",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "RAJEEV   GARG",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "S K VERMA",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "R A S KUSHWAHA",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SIDDHARTH KUMAR",
      "DASRHEUMATO"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "SUHAIL AHMED QIDWAI",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "LUCKNOW",
      "Lucknow",
      "Y K ARORA",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "BRIJESH   SINGH",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "ANIL   AHUJA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "ONKAR   SINGH",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "SUNIL   VERMA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "MANISH   DWIVEDI",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "BHUPESH   NARANG",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "PRAMOD   KUMAR",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "RAIBAREILLY",
      "Lucknow",
      "RAHUL   MISHRA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "VIMAL   PALIWAL",
      "NEUROLOGIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "ANIL   AGARWAL",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "SANJOY KUMAR SUREKA",
      "ORTHOPEDICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "ALOK   NATH",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "AJMAL   KHAN",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "JIA   HASMI",
      "CHEST SPECIALIST"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "SANDEEP   KHUBA",
      "CONSULTANT PHYSICIAN"
    ],
    [
      "India",
      "UTTAR PRADESH",
      "S.G.P.G.I.",
      "Lucknow",
      "SUJEET   GAUTAM",
      "ORTHOPEDICIAN"
    ],
  ];

  String defaultPassword = "123456789";

  void _registerAllAccount() async {
    setState(() {
      signingup = true;
    });
    User user;
    UserCredential credential;

    FirebaseApp app = Firebase.app('SecondaryApp');

    for (var i = 0; i < userDatas.length; i++) {
      var value = userDatas[i];

      try {
        credential = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: value[4].replaceAll(RegExp(' +'), '_') + "@gmail.com", password: defaultPassword);
        print(" User: " + i + " account created");
      } catch (error) {
        print(" User: " + i + " sign in error: " + error.message);
      }
      user = credential.user;

      if (user != null) {
        try {
          await user.updateProfile(displayName: value[4]);
          await _firestore.collection('users').doc(user.uid).set({
            'name': value[4],
            'email': value[4].replaceAll(RegExp(' +'), '_') + "@gmail.com",
            'phone': null,
            'role': widget.type == "doctor" ? "DOCTOR" : "ASSOCIATE",
            'approved': 'ONPROGRESS',
            'type': value[5],
            'location': null,
            'locality': value[2],
            'city': value[3],
            'state': value[1],
            'country': value[0],
            'aboutme': null,
          }, SetOptions(merge: true));

          print(" User: " + i + " profie added");
        } catch (error) {
          print(" User: " + i + " profile add error: " + error.message);
        }
      }
    }
    setState(() {
      signingup = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _registerAllAccount();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
        inAsyncCall: signingup,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100,
                  child: HeaderWidget(100, false, Icons.house_rounded),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(25, 25, 25, 10),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            GestureDetector(
                              child: Stack(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(width: 5, color: Colors.white),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 20,
                                          offset: const Offset(5, 5),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.grey.shade300,
                                      size: 80.0,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(80, 80, 0, 0),
                                    child: Icon(
                                      Icons.add_circle,
                                      color: Colors.grey.shade700,
                                      size: 25.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration('Name', 'Enter doctor name'),
                                obscureText: false,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  return null;
                                },
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                focusNode: _nameFocus,
                                onFieldSubmitted: (term) {
                                  FocusScope.of(context).requestFocus(_emailFocus);
                                },
                                onEditingComplete: () {},
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration("E-mail address", "Enter doctor email"),
                                keyboardType: TextInputType.emailAddress,
                                validator: (val) {
                                  if (!(val.isEmpty) && !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)) {
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                                obscureText: false,
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                focusNode: _emailFocus,
                                onFieldSubmitted: (term) {
                                  FocusScope.of(context).requestFocus(_phoneFocus);
                                },
                                onEditingComplete: () {},
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                decoration: ThemeHelper().textInputDecoration("Mobile Number", "Enter doctor mobile number"),
                                keyboardType: TextInputType.phone,
                                validator: (val) {
                                  if (!(val.isEmpty) && !RegExp(r"^(\d+)*$").hasMatch(val)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                                obscureText: false,
                                controller: phoneController,
                                textInputAction: TextInputAction.next,
                                focusNode: _phoneFocus,
                              ),
                              decoration: ThemeHelper().inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 40.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(context),
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text(
                                    "Register".toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _registerAccount();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _registerAccount() async {
    User user;
    UserCredential credential;

    setState(() {
      signingup = true;
    });
    FirebaseApp app = Firebase.app('SecondaryApp');
    //FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);

    try {
      credential = await FirebaseAuth.instanceFor(app: app).createUserWithEmailAndPassword(email: emailController.text, password: defaultPassword);
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ThemeHelper().alartDialog("Error", error.message, context);
        },
      );
      setState(() {
        signingup = false;
      });
    }
    user = credential.user;

    if (user != null) {
      try {
        await user.updateProfile(displayName: nameController.text);

        await _firestore.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'role': widget.type == "doctor" ? "DOCTOR" : "ASSOCIATE",
          'approved': 'ONPROGRESS',
          'type': null,
          'location': null,
          'locality': null,
          'city': null,
          'state': null,
          'country': null,
          'aboutme': null,
        }, SetOptions(merge: true));

        if (widget.type == "doctor") {
        } else {}
        // todo back to doctors list
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()), (Route<dynamic> route) => false);
        nameController.text = "";
        emailController.text = "";
        phoneController.text = "";
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ThemeHelper().alartDialog("Success", "User added successfully!", context);
          },
        );
        setState(() {
          signingup = false;
        });
      } catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ThemeHelper().alartDialog("Error", error.message, context);
          },
        );
        setState(() {
          signingup = false;
        });
      }
    } else {
      setState(() {
        signingup = false;
      });
    }
    //await app.delete();
  }
}
