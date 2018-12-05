import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(NDApp());

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

  static Future<bool> setHighestAvailLevel(int lvl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setInt(_highestAvailLevel, lvl);
  }

  static Future<int> getHighestAvailLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_highestAvailLevel) ?? 1;
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
  int _currLevel;

  _initialLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currLevel = prefs.getInt("hal") ?? 1;
    });

  }

  List<Widget> buttonsFromList(List<int> list) {
    List<Widget> btns = List();
    for (int i in list) {
      btns.add(RaisedButton(onPressed: null,
          child: Text(i.toString(), style: textStyle)));
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
                style: textStyle), onPressed: null),
            FlatButton(child: Text("Settings",
                style: textStyle),
                onPressed: () {Navigator.pushNamed(context, '/settings');},
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(child: Text("$_currLevel")),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text("", style: textStyle,
                    textDirection: TextDirection.rtl,),
                ),
                RaisedButton(
                  child: Text("v", style: textStyle), onPressed: () {
                    setState(() {
                      _currLevel++;
                    });
                },),
                RaisedButton(
                  child: Text("<-", style: textStyle),
                  onPressed: null,),

              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonsFromList([0,1,2,3,4]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: buttonsFromList([5,6,7,8,9]),
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