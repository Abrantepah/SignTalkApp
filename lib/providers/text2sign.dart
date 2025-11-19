import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TextToSignProvider with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _apiResponse;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get apiResponse => _apiResponse;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// 📝 Send text to backend
  Future<void> sendText(String text) async {
    _setLoading(true);
    try {
      _apiResponse = await ApiService.sendText(text);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  /// 🎤 Send audio (works with File or XFile)
  Future<void> sendAudio(dynamic audioFile) async {
    _setLoading(true);
    try {
      _apiResponse = await ApiService.sendAudio(audioFile);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  /// 🧹 Clear previous API response
  void clearResponse() {
    _apiResponse = null;
    notifyListeners();
  }
}
