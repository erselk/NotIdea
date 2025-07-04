import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _comingSoon = false;
  bool get comingSoon => _comingSoon;
  set comingSoon(bool value) {
    _comingSoon = value;
  }

  bool _notification = false;
  bool get notification => _notification;
  set notification(bool value) {
    _notification = value;
  }
}
