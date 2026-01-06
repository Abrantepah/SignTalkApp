import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ApiConstants {
  static const String baseUrl = "https://signtalkgh.com/api";
  static const String baseMediaUrl = "https://signtalkgh.com";
  static const String textAudioToSign = "/text-audio-to-sign/";
  static const String signToText = "/sign-to-text/";
}

class ColorsConstant {
  static const Color extra = Color.fromARGB(255, 25, 82, 21);
  static const Color primary = Color.fromARGB(255, 69, 95, 67); // Deep Blue
  static const Color secondary = Color(0xFF578FCA); // Medium Blue
  static const Color tertiary = Color(0xFFA1E3F9); // Light Sky Blue
  static const Color accent = Color(0xFFD1F8EF); // Soft Aqua
  static const Color textColor = Color(0xFF0A0A0A); // Dark Text
  static const Color background = Color(0xFFF8FAFC); // Very Light Background
  static const Color softPurple = Color(0xFF6C5CE7); // Soft Purple
  static const Color safeRed = Color.fromARGB(255, 212, 8, 8); // Light Gray
  static const Color darkPurple = Color(0xFF2C2F48); // Dark Gray
}

class FontsConstant {
  // Headings (bold & modern)
  static TextStyle headingLarge = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle headingMedium = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );

  // Body text (clean & readable)
  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Colors.black87,
  );

  static TextStyle bodySmall = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: Colors.black54,
  );

  // Buttons / Labels
  static TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
