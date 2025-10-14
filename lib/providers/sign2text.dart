import 'dart:typed_data';
import 'package:cross_file/cross_file.dart'; // For XFile
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignToTextProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, dynamic>? _apiResponse;
  Map<String, dynamic>? get apiResponse => _apiResponse;

  /// Works for both Web (XFile or Uint8List) and Mobile (File)
  Future<Map<String, dynamic>?> sendVideo(
    dynamic videoFile,
    String category,
  ) async {
    _setLoading(true);
    try {
      _apiResponse = await ApiService.sendVideo(videoFile, category);
      debugPrint("✅ API Response: $_apiResponse");
      _errorMessage = null;
    } catch (e, stack) {
      _errorMessage = e.toString();
      debugPrint("❌ Error sending video: $e\n$stack");
    } finally {
      _setLoading(false);
    }
    notifyListeners();
    return _apiResponse;
  }

  void clearResponse() {
    _apiResponse = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
