import 'package:numberdumper/SharedPreferencesHelper.dart';
import 'package:scoped_model/scoped_model.dart';

class NDModel extends Model {
  int currLevel;
  bool isHintAvail;
  bool isMusicEnabled;
  bool isSoundEnabled;

  NDModel() {
    SharedPreferencesHelper.getHighestAvailLevel()
        .then((int value) {currLevel = value;});
    SharedPreferencesHelper.getIsHintAvail(currLevel)
        .then((bool value) {isHintAvail = value;});
    notifyListeners();
  }

  void setIsHintAvail(bool value) {
    isHintAvail = value;
  }

  int getCurrentLevel() {
    return currLevel ?? 1;
  }

  void nextLevel() {
    currLevel++;
    SharedPreferencesHelper.getHighestAvailLevel().then((int value) {
      if (currLevel > value ) {
        SharedPreferencesHelper.setHighestAvailLevel(currLevel);
      }
    });
    SharedPreferencesHelper.getIsHintAvail(currLevel)
        .then((bool value) {isHintAvail = value;});
    notifyListeners();
  }
}