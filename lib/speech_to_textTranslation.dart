import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';


void requestMicrophonePermission() async {
  PermissionStatus status = await Permission.microphone.request();
  if (status.isGranted) {
    // Microphone permission is granted
  } else {
    // Handle denied permission
  }
}




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpeechToTextTranslationScreen(),
    );
  }
}


class SpeechToTextTranslationScreen extends StatefulWidget {
  @override
  _SpeechToTextTranslationScreenState createState() => _SpeechToTextTranslationScreenState();
}

class _SpeechToTextTranslationScreenState extends State<SpeechToTextTranslationScreen> {
  var language_code = 'hi-IN'; // Default language
  bool _isSending = false;
  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = "Press the button to start speaking";
  String _translatedText = ""; // Add a variable to store the translated text

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  // Function to start listening and capture speech
  Future<void> _startListening() async {
    bool available = await _speech!.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speech!.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
      });
    }
  }

  // Function to send speech text to Sarvam API and translate it
  Future<void> _translateText(String text) async {
    var url = Uri.parse('https://api.sarvam.ai/translate'); // Assuming Sarvam has a translate endpoint
    var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'api-subscription-key': '82762314-dc16-44a1-8ed8-ddb06d32e316',
        },

        body: jsonEncode({
      "input": text ?? "", // Ensure text is not null
      "source_language_code": "en-IN",
      "target_language_code": language_code,
      "speaker_gender": "Male",
      "mode": "formal",
      "model": "mayura:v1",
      "enable_preprocessing": true // Target language based on user selection
        }),
    );



    if (response.statusCode == 200) {
      // Decode the response ensuring UTF-8 handling
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      print('Translation passed with status: ${response.statusCode}  && ${jsonResponse}');
      setState(() {
        _translatedText = jsonResponse['translated_text'] ?? 'Translation unavailable';
      });
    } else {
      print('Translation failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('S T T Screen')
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_text), // Display the recognized speech text
              SizedBox(height: 20),
              DropdownButton<String>(
                value: language_code,
                items: <String>[
                  "hi-IN", "bn-IN", "kn-IN", "ml-IN", "mr-IN", "od-IN",
                  'pa-IN', 'ta-IN', 'te-IN', 'gu-IN', 'en-IN'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    language_code = newValue!;
                  });
                },
              ),
              ElevatedButton(
                onPressed: _isListening ? null : _startListening,
                child: Text('Start Listening'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSending ? null : () => _translateText(_text), // Send for translation
                child: Text('Translate Text'),
              ),
              SizedBox(height: 20),
              Text(_translatedText), // Display the translated text
            ],
          ),
        ),

    );
  }
}