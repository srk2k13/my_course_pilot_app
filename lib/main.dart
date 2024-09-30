import 'package:flutter/material.dart';
import 'package:my_course_pilot/speech_to_textTranslation.dart';
import 'package:my_course_pilot/speechto_text.dart';
import 'package:my_course_pilot/text_to_speech.dart';
import 'package:my_course_pilot/translate_text.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'media_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  String translatedText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Course Creation Copilot") ,centerTitle:true,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to Screen2 when the button is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TranslationScreen()),
                );
              },
              child: Text('Translate Text'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Screen2 when the button is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TTSScreen()),
                );
              },
              child: Text('Text To Speech'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Screen2 when the button is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeechToTextTranslationScreen()),
                );
              },
              child: Text("Speech to Text and Translation"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Screen2 when the button is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MediaScreen()),
                );
              },
              child: Text("Add Media"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Screen2 when the button is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SpeechToTextPage()),
                );
              },
              child: Text("Speech To Text"),
            ),
            SizedBox(height: 20),


          ],
        ),
      ),
    );
  }
}
