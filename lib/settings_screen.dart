import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {

  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {


  final textStyle = TextStyle(color: Colors.white, fontSize: 24.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0,),
      body: Padding(padding: EdgeInsets.all(32.0) ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Music", style: textStyle,),
                RaisedButton(child: Text("ON", style: textStyle,),
                  onPressed: null,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Sound FX", style: textStyle,),
                RaisedButton(child: Text("ON", style: textStyle,),
                  onPressed: null,)
              ],
            ),
          ],
        ),)
    );
  }
}