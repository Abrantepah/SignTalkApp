import 'dart:convert';
import 'dart:io' as io;
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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
      throw io.HttpException(
        "Failed: ${response.statusCode}, ${response.body}",
      );
    }
  }

  /// 🎤 Send audio file (works on Web & Mobile)
  static Future<Map<String, dynamic>> sendAudio(dynamic audioFile) async {
    final url = Uri.parse(
      "${ApiConstants.baseUrl}${ApiConstants.textAudioToSign}",
    );

    final request = http.MultipartRequest("POST", url);

    if (kIsWeb) {
      if (audioFile is XFile) {
        print("🌐 Web audio upload: ${audioFile.name}");
        final bytes = await audioFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          "audio",
          bytes,
          filename: "recorded_audio.wav",
          contentType: MediaType("audio", "wav"),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception("Web requires XFile for audio upload");
      }
    } else {
      if (audioFile is io.File) {
        print("📱 Mobile audio upload: ${audioFile.path}");
        request.files.add(
          await http.MultipartFile.fromPath(
            "audio",
            audioFile.path,
            contentType: MediaType("audio", "wav"),
          ),
        );
      } else if (audioFile is XFile) {
        final multipartFile = await http.MultipartFile.fromPath(
          "audio",
          audioFile.path,
          contentType: MediaType("audio", "wav"),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception("Unsupported audio type: ${audioFile.runtimeType}");
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print("📡 Audio Upload Response: ${response.statusCode}");
    print(response.body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw io.HttpException(
        "Failed: ${response.statusCode}, ${response.body}",
      );
    }
  }

  /// 🎥 Send video (works on Web & Mobile)
  static Future<Map<String, dynamic>> sendVideo(
    dynamic videoFile,
    String category,
  ) async {
    final url = Uri.parse("${ApiConstants.baseUrl}${ApiConstants.signToText}");
    final request = http.MultipartRequest("POST", url);
    request.fields['category'] = category;

    if (kIsWeb) {
      if (videoFile is XFile) {
        final bytes = await videoFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'video',
          bytes,
          filename: 'recorded_video.mp4',
          contentType: MediaType('video', 'mp4'),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception("Web camera output must be XFile.");
      }
    } else {
      if (videoFile is io.File) {
        final multipartFile = await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
          contentType: MediaType('video', 'mp4'),
        );
        request.files.add(multipartFile);
      } else if (videoFile is XFile) {
        final multipartFile = await http.MultipartFile.fromPath(
          'video',
          videoFile.path,
          contentType: MediaType('video', 'mp4'),
        );
        request.files.add(multipartFile);
      } else {
        throw Exception(
          "Unsupported video file type: ${videoFile.runtimeType}",
        );
      }
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Upload failed: ${response.statusCode} ${response.body}");
    }
  }
}
