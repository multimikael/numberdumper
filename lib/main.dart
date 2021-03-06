import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:numberdumper/NDModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:numberdumper/settings_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_admob/firebase_admob.dart';

const appId = "ca-app-pub-9951612794243198~4065402206";
const hintUnitId = "ca-app-pub-9951612794243198/4939500178";
const targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['Games', 'Puzzles'],
    testDevices: <String>[]);

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
        runApp(NDApp());
      });
  FirebaseAdMob.instance.initialize(appId: appId);
  RewardedVideoAd.instance.load(adUnitId: hintUnitId,
      targetingInfo: targetingInfo);
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

  Widget _hintButton(model) {
    RewardedVideoAd.instance.load(
        adUnitId: hintUnitId,
        targetingInfo: targetingInfo);
    RewardedVideoAd.instance.listener =
        (RewardedVideoAdEvent event,
        {String rewardType, int rewardAmount}) {
      print(rewardType);
      if (event == RewardedVideoAdEvent.rewarded) {
        RewardedVideoAd.instance.listener = null;
        model.setIsHintAvail(true);
        _showHintDialog();
        RewardedVideoAd.instance.load(
            adUnitId: hintUnitId,
            targetingInfo: targetingInfo);
      }
    };
    return FlatButton(child: Text("Hint",
        style: textStyle),
        onPressed: () {
          print(model.isHintAvail);
          print(model.getCurrentLevel());
          if (model.isHintAvail) {
            _showHintDialog();
          } else {
            RewardedVideoAd.instance.show();
          }
        });
  }

  Future<void> _showHintDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxHeight: 300.0),
                  child: GestureDetector(
                    onTap: () {Navigator.pop(context);},
                    child: ScopedModelDescendant<NDModel>(
                        builder: (context, _, model) =>
                            SvgPicture.asset(
                              'assets/hints/hintlevel' +
                                  model.getCurrentLevel().toString() + '.svg',
                              fit: BoxFit.fitHeight,)),
                  )
                )
              ]);
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        title: Padding(padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ScopedModelDescendant<NDModel>(
                builder: (context, _, model) =>
                    _hintButton(model)
              ),
              FlatButton(child: Text("Settings",
                  style: textStyle),
                onPressed: () {Navigator.pushNamed(context, '/settings');},
              ),
            ],
          ),)
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(padding: EdgeInsets.all(32.0),
                child: ScopedModelDescendant<NDModel>(
                    builder: (context, _, model) =>
                        SvgPicture.asset('assets/level' +
                            model.getCurrentLevel().toString() + '.svg')),)
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    style: textStyle,
                    //Remove underline
                    decoration: InputDecoration.collapsed(hintText: null),
                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.center,
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
                        highlightColor: Colors.green,
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