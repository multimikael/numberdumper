import 'package:flutter/material.dart';
import 'package:numberdumper/NDModel.dart';
import 'package:scoped_model/scoped_model.dart';

class SettingsScreen extends StatefulWidget {

  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final String about = "Hello, this section is not done yet";

  final textStyle = TextStyle(color: Colors.white, fontSize: 24.0);
  final aboutTextStyle = TextStyle(color: Colors.white, fontSize: 16.0);

  Widget _forwardButton(NDModel model) {
    Widget btn = IconButton(icon: Icon(Icons.arrow_forward),
      onPressed: () {model.nextLevel();},
      color: Colors.white,);
    return model.isNextLevelAvail
        ? btn
        : IconButton(icon: SizedBox(width: 24.0, height: 24.0),
            onPressed: null);
  }

  Widget _backButton(NDModel model) {
    Widget btn = IconButton(icon: Icon(Icons.arrow_back),
      onPressed: () {model.lastLevel();},
      color: Colors.white,);
    return model.isLastLevelAvail
        ? btn
        : IconButton(icon: SizedBox(width: 24.0, height: 24.0),
            onPressed: null);
  }

  Widget _currLevelText(NDModel model) {
    return model.currLevel > 24
        ? Text("FINISH", style: textStyle)
        : Text(model.currLevel.toString(), style: textStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0.0,),
      body: Padding(padding: EdgeInsets.all(32.0) ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ScopedModelDescendant<NDModel>(builder: (context, _, model) =>
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _backButton(model),
                    _currLevelText(model),
                    _forwardButton(model)
                  ],
                )),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(about, style: aboutTextStyle),
                  /*Row(
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
                  ),*/
                ],
              ),
            )
          ],
        ),)
    );
  }
}