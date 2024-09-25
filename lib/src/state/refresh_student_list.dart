import 'package:flutter/foundation.dart';

class RefreshPage extends ChangeNotifier {
  bool _value = false;
  bool get value => _value;

  void refresh() {
    _value = true;
    notifyListeners();
  }
}
