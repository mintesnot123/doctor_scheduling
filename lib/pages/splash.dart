import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:yismaw/widgets/custombutton.dart';
import 'package:yismaw/pages/register.dart';
import 'package:yismaw/pages/login.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  /* AnimationController mainController;
  Animation mainAnimation;
  @override
  void initState() {
    super.initState();
    mainController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    mainAnimation = ColorTween(begin: Colors.deepPurple[900], end: Colors.grey[100]).animate(mainController);
    mainController.forward();
    mainController.addListener(() {
      setState(() {});
    });
  } */
  bool _isVisible = false;

  _SplashPageState() {
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginPage()), (route) => false);
      });
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible = true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'heroicon',
      child: Icon(
        Icons.medical_services,
        size: mainController.value * 100,
        color: Colors.deepPurple[900],
      ),
    );

    final logoText = Hero(
      tag: 'HeroTitle',
      child: Text(
        'My Doctor',
        style: TextStyle(color: Colors.deepPurple[900], fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w700),
      ),
    );

    final animatedText = TyperAnimatedTextKit(
      isRepeatingAnimation: false,
      speed: Duration(milliseconds: 60),
      text: [
        "Doctors scheduling app".toUpperCase()
      ],
      textStyle: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.deepPurple),
    );

    final navToLoginBtn = Hero(
      tag: 'loginbutton',
      child: CustomButton(
        text: 'Login',
        accentColor: Colors.deepPurple,
        onpress: () {
          _pushPage(context, LoginPage());
          //Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );

    final navToRegisterBtn = Hero(
      tag: 'signupbutton',
      child: CustomButton(
        text: 'Signup',
        accentColor: Colors.white,
        mainColor: Colors.deepPurple,
        onpress: () {
          _pushPage(context, RegisterPage());
          //Navigator.pushReplacementNamed(context, '/register');
        },
      ),
    );

    final footer = Hero(
      tag: 'footer',
      child: Text(
        'Made with ♥ by Horizon Tech',
        style: TextStyle(fontFamily: 'Poppins'),
      ),
    );

    /* return Scaffold(
      backgroundColor: mainAnimation.value,
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                logo,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                logoText,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                animatedText,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                navToLoginBtn,
                SizedBox(
                  height: 10,
                ),
                navToRegisterBtn,
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                footer,
              ],
            ),
          ),
        ),
      ),
    ); */
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [
            Theme.of(context).accentColor,
            Theme.of(context).primaryColor
          ],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [
            0.0,
            1.0
          ],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child: Center(
              child: ClipOval(
                child: Icon(
                  Icons.android_outlined,
                  size: 128,
                ), //put your logo here
              ),
            ),
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 2.0,
                offset: Offset(5.0, 3.0),
                spreadRadius: 2.0,
              )
            ]),
          ),
        ),
      ),
    );
  }

  void _pushPage(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
