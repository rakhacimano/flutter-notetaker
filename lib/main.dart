import 'package:flutter/material.dart';
import 'package:notetaker/pages/notataker_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const NotetakerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
