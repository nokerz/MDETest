// lib/providers/header_provider.dart
import 'package:flutter/material.dart';

class HeaderProvider extends ChangeNotifier {
  String _title = 'My App';
  bool _isSearchActive = false;

  String get title => _title;
  bool get isSearchActive => _isSearchActive;

  void updateTitle(String newTitle) {
    _title = newTitle;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearchActive = !_isSearchActive;
    notifyListeners();
  }
}
