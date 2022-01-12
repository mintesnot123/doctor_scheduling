import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:yismaw/pages/splash.dart';
import 'package:yismaw/pages/login.dart';
import 'package:yismaw/pages/register.dart';
import 'package:yismaw/pages/adminPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    _getUser();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doctors scheduling',
        theme: ThemeData(
          textTheme: TextTheme(
            bodyText1: TextStyle(fontFamily: 'Poppins'),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => user == null ? SplashPage() : MyHomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          //'/home': (context) => MyHomePage(),
          '/home': (context) => /* user == null ? LoginPage() :  */ MainPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  static String tag = '/home-page';
  final List<Page> _pages = [
    Page('Home', Icons.home),
    Page('Feedback', Icons.feedback),
    Page('Profile', Icons.person_outline),
  ];

  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentPageIndex = 0;

  void _openPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerItemWidgets = widget._pages
        .asMap()
        .map((int index, Page page) => MapEntry<int, Widget>(
            index,
            ListTile(
              title: Text(page.title),
              leading: Icon(page.iconData),
              selected: _currentPageIndex == index,
              onTap: () {
                _openPage(index);
                Navigator.pop(context);
              },
            )))
        .values
        .toList();
    drawerItemWidgets.insert(
      0,
      DrawerHeader(
        child: Text('Drawer Header'),
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Bottom Navigation Bar and Drawer Page"),
      ),
      body: Center(
        child: Text(widget._pages[_currentPageIndex].title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerItemWidgets,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        items: widget._pages
            .map((Page page) => BottomNavigationBarItem(
                  icon: Icon(page.iconData),
                  title: Text(page.title),
                ))
            .toList(),
        onTap: _openPage,
      ),
    );
  }
}

class Page {
  final String title;
  final IconData iconData;
  Page(this.title, this.iconData);
}
