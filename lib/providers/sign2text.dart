import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignToTextProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _apiResponse;
  Map<String, dynamic>? get apiResponse => _apiResponse;

  Future<void> sendVideo(File videoFile) async {
    _setLoading(true);
    try {
      _apiResponse = await ApiService.sendVideo(videoFile);
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

  /// 🔄 Update loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
