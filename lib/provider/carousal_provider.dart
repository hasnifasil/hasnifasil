import 'package:flutter/cupertino.dart';

class Carousal extends ChangeNotifier {
  int activeIndex = 0;
  getIndex(int i) {
    activeIndex = i;
    notifyListeners();
  }
}
