import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  int _counter = 0;
  String _userName = "Invitado";
  bool _allowReset = true;

  //get's
  int get counter => _counter;
  String get userName => _userName;
  bool get allowReset => _allowReset;

  //meotodos contador
  void incrementCounter() {
    _counter++;
    notifyListeners();  //notifica a los widget
  }

  void decrementCounter() {
    _counter--;
    notifyListeners();
  }

  void resetCounter() {
    if (_allowReset) {
      _counter = 0;
      notifyListeners();
    }
  }

  void updateUser(String newName) {
    _userName = newName;
    notifyListeners();
  }

  void toggleReset(bool value) {
    _allowReset = value;
    notifyListeners();
  }
}