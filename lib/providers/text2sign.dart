import 'dart:io';
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

  Future<void> sendAudio(File audioFile) async {
    _setLoading(true);
    try {
      _apiResponse = await ApiService.sendAudio(audioFile);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    _setLoading(false);
  }

  void clearResponse() {
    _apiResponse = null;
    notifyListeners();
  }
}
