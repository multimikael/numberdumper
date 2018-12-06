import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberdumper/NDModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberdumper/settings_screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(NDApp());
      });
}

class NDApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: NDModel(),
      child: MaterialApp(
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
      ),
    );
  }
}

class MainScreen extends StatefulWidget {

  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final answers = [8,8,7,8,13,1,12,25,17,9,128,11,13,3,2,50,36,4,9,25,20,1,21,7];
  final textStyle = TextStyle(color: Colors.white);
  final answerController = TextEditingController();

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
            ScopedModelDescendant<NDModel>(
              builder: (context, _, model) =>
                  FlatButton(child: Text("Hint",
                  style: textStyle),
                  onPressed: () {
                    print(model.isHintAvail);
                    print(model.currLevel);
                    if (model.isHintAvail) {
                      //TODO: Show hint
                    } else {
                      model.setIsHintAvail(true);
                    }
                  }),
            ),
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
              child: ScopedModelDescendant<NDModel>(
                  builder: (context, _, model) =>
                      Image(image: AssetImage('assets/level' +
                          model.currLevel.toString()),)),
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
                  ScopedModelDescendant<NDModel>(builder: (context, _, model) =>
                      IconButton(
                        icon: Icon(Icons.check),
                        color: Colors.white,
                        onPressed: () {
                          // current level-1 since index starts at 0
                          if (answerController.text ==
                              answers[model.currLevel-1].toString()) {
                            model.nextLevel();
                          }
                          answerController.text = "";
                        },)),],)],
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}