import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:signtalk/utils/constants.dart';

class ApiService {
  /// 🟩 Send text to API
  static Future<Map<String, dynamic>> sendText(String text) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.textAudioToSign}",
    );

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": text}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException("Failed: ${response.statusCode}, ${response.body}");
    }
  }

  /// 🎤 Send audio file to API
  static Future<Map<String, dynamic>> sendAudio(File audioFile) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.textAudioToSign}",
    );

    final request = http.MultipartRequest("POST", url);
    request.files.add(
      await http.MultipartFile.fromPath("audio", audioFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException("Failed: ${response.statusCode}, ${response.body}");
    }
  }

  /// 🎥 Send video file to API
  static Future<Map<String, dynamic>> sendVideo(File videoFile) async {
    final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.signToText}");

    final request = http.MultipartRequest("POST", url);
    request.files.add(
      await http.MultipartFile.fromPath("video", videoFile.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw HttpException("Failed: ${response.statusCode}, ${response.body}");
    }
  }
}
