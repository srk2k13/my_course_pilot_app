import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SpeechToTextPage(),
    );
  }
}

void requestMicrophonePermission() async {
  PermissionStatus status = await Permission.microphone.request();
  if (status.isGranted) {
    // Microphone permission is granted
  } else {
    // Handle denied permission
  }
}

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  String _translatedText = "Translated text is "; // Initial text for translation

  stt.SpeechToText? _speech;
  bool _isListening = false;
  String _text = "Press the button to start speaking";

  var language_code = 'en-IN';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

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



  void _uploadFileForMobile() {
    // Add your file upload logic for mobile here
  }

  Future<void> _SpeechToText(String text) async {
    var url = Uri.parse('https://api.sarvam.ai/speech-to-text');


      // Mobile and desktop implementation
      var request = http.MultipartRequest('POST', url);

      var audioFile = await http.MultipartFile.fromPath('file', 'path/to/your/audio/file.mp3');
      request.files.add(audioFile);

      request.fields['model'] = 'saarika:v1';
      request.fields['language_code'] = 'hi-IN'; // Your chosen language code

      request.headers['Content-Type'] = 'application/json';
      request.headers['api-subscription-key'] = '82762314-dc16-44a1-8ed8-ddb06d32e316';

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("Success: ${response.body}");
      } else {
        print("Error: ${response.body}");
      };

  }

  // Function to display the translated text
  void _displayTranslatedText() {
  setState(() {
  _translatedText = "Translated text is: $_text"; // Show the translated text
  });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(title: Text("Speech to Text Screen")),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_text),
          SizedBox(height: 20),
         /* DropdownButton<String>(
            value: language_code,
            items: <String>['hi-IN', 'bn-IN', 'kn-IN', 'ml-IN', 'mr-IN', 'od-IN', 'pa-IN', 'ta-IN', 'te-IN', 'gu-IN']
                .map((String value) {
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
          ),*/
          ElevatedButton(
            onPressed: _isListening ? null : _startListening,
            child: Text('Start Listening'),
          ),
          SizedBox(height: 20),
   /* ElevatedButton(
            onPressed: () => _SpeechToText(_text),
            child: Text('Send to Sarvam API'),
          ),*/
          SizedBox(height: 20),
          Text(_translatedText), // This will display the updated translated text
  SizedBox(height: 20),



  ElevatedButton(
  onPressed: _displayTranslatedText, // Button to display translated text
  child: Text("Display the Translated Text"),
  ),
  ],
  ),
  ),
  );
  }
  }

