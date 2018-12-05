import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(NDApp());
      });
}

class NDApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Dumper',
      theme: ThemeData(
        canvasColor: Colors.grey[800],
        primaryColor: Colors.grey[800],
        buttonTheme: ButtonThemeData(
          minWidth: 30.0)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}

class SharedPreferencesHelper {
  static final _highestAvailLevel = "hal";
  static final _isMusicEnabled = "isMusicEnabled";
  static final _isSoundEnabled = "isSoundEnabled";
  static final _isHintAvail = "hint";

  static Future<bool> setHighestAvailLevel(int level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_highestAvailLevel, level);
  }

  static Future<bool> setIsHintAvail(int level, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(_isHintAvail+level.toString(), value);
  }

  static Future<int> getHighestAvailLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestAvailLevel) ?? 1;
  }

  static Future<bool> getIsHintAvail(int level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isHintAvail+level.toString()) ?? false;
  }

  static Future<bool> getIsMusicEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isMusicEnabled) ?? true;
  }

  static Future<bool> getIsSoundEnabled() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isSoundEnabled) ?? true;
  }
}

class MainScreen extends StatefulWidget {

  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final textStyle = TextStyle(color: Colors.white);
  final answers = [1,2,3,4];
  final answerController = TextEditingController();
  int _currLevel;
  bool _isHintAvail;

  _MainScreenState() {
    SharedPreferencesHelper.getHighestAvailLevel()
        .then((int value) {setState(() {_currLevel = value;});});
    SharedPreferencesHelper.getIsHintAvail(_currLevel)
        .then((bool value) {setState(() {_isHintAvail = value;});});
  }

  List<Widget> buttonsFromList(List<int> list) {
    List<Widget> btns = List();
    for (int i in list) {
      btns.add(Expanded(child: FlatButton(
          onPressed: () {
            answerController.text += i.toString();
          },
          child: Text(i.toString(), style: textStyle))));
    }
    return btns;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FlatButton(child: Text("Hint",
                style: textStyle),
                onPressed: () {
                  print(_isHintAvail);
                  if (_isHintAvail) {
                    //TODO: Show hint
                  } else {
                    SharedPreferencesHelper.setIsHintAvail(_currLevel, true);
                    setState(() {_isHintAvail = true;});
                  }
                }),
            FlatButton(child: Text("Settings",
                style: textStyle),
                onPressed: () {Navigator.pushNamed(context, '/settings');},
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text("$_currLevel"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    style: textStyle,
                    //Remove underline
                    decoration: InputDecoration.collapsed(hintText: null),
                    textDirection: TextDirection.rtl,
                    controller: answerController,),
                ),
                IconButton(
                  icon: Icon(Icons.backspace),
                  color: Colors.white,
                  onPressed: () {
                    setState(() {
                      answerController.text = answerController.text
                          .substring(0, answerController.text.length-1);
                    });
                  },),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: buttonsFromList([0,1,2,3,4]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: buttonsFromList([5,6,7,8,9]),
                      ),
                    ],),),
                Column(children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check),
                    color: Colors.white,
                    onPressed: () {
                      // current level-1 since index starts at 0
                      if (answerController.text ==
                          answers[_currLevel-1].toString()) {
                        setState(() {_currLevel++;});
                      }
                      answerController.text = "";
                    },),
                  ],)],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SettingsScreen extends StatefulWidget {

  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final textStyleON = TextStyle(color: Colors.white,
      decoration: TextDecoration.underline, decorationColor: Colors.blue);

  final textStyle = TextStyle(color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Music"),
              FlatButton(child: Text("ON", style: textStyleON,),
                onPressed: null,)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Sound FX"),
              FlatButton(child: Text("ON", style: textStyleON,),
                onPressed: null,)
            ],
          ),
        ],
      ),
    );
  }
}