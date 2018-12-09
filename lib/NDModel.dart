import 'package:numberdumper/SharedPreferencesHelper.dart';
import 'package:scoped_model/scoped_model.dart';

class NDModel extends Model {
  int currLevel;
  bool isHintAvail;
  bool isMusicEnabled;
  bool isSoundEnabled;
  bool isNextLevelAvail = false;
  bool isLastLevelAvail;

  NDModel() {
    SharedPreferencesHelper.getHighestAvailLevel()
        .then((int value) {
          currLevel = value;
          isLastLevelAvail = currLevel > 1;
        });
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

  void setCurrentLevel(int level) {
    currLevel = level;
    SharedPreferencesHelper.getIsHintAvail(currLevel)
        .then((bool value) {isHintAvail = value;});
    SharedPreferencesHelper.getHighestAvailLevel().then((int value) {
      if (currLevel > value ) {
        SharedPreferencesHelper.setHighestAvailLevel(currLevel);
      }
      isNextLevelAvail = currLevel < value;
    });
    isLastLevelAvail = currLevel > 1;
    notifyListeners();
  }

  void lastLevel() {
    setCurrentLevel(currLevel-1);
  }

  void nextLevel() {
    setCurrentLevel(currLevel+1);
  }
}