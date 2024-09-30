import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;


class TTSScreen extends StatefulWidget {
  @override
  _TTSScreenState createState() => _TTSScreenState();
}

class _TTSScreenState extends State<TTSScreen> {
  FlutterTts flutterTts = FlutterTts();
  final TextEditingController ttsController = TextEditingController();
  String transcript = '';
  Future<void> textToSpeech(String text, String target_language_code) async {
    var url = Uri.parse('https://api.sarvam.ai/text-to-speech');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'api-subscription-key': '82762314-dc16-44a1-8ed8-ddb06d32e316',
      },
      body: jsonEncode({
         "inputs": ["""Welcome Shravan what can I do for you"""],
       // "input": text ?? "", // Ensure text is not null
        'target_language_code': 'en-IN',
        'speaker': 'meera',
        'pitch': 0,
        'pace': 1.65,
        'loudness': 1.5,
        'speech_sample_rate': 8000,
        'enable_preprocessing': true,
        'model': 'bulbul:v1',
      }),
    );


    // Check and handle the response
    try {
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      print('Text converted to speech or audio  with status: ${response.statusCode}  && ${jsonResponse}');

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        setState(() {
          transcript = jsonResponse['audio'] ?? 'audio unavailable';
        });
      } else {
        print('Failed to get TTS response. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text to Speech Screen")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: ttsController),
            ElevatedButton(
              onPressed: () {
                flutterTts.speak(ttsController.text);
               // textToSpeech;
              },
              child: Text("Play Speech"),
            ),
          ],
        ),
      ),
    );
  }
}



