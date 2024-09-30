


import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TranslationScreen(),
    );
  }
}

class TranslationScreen extends StatefulWidget {
  @override
  _TranslationScreenState createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  TextEditingController _translationController = TextEditingController();
  String translatedText = '';
  var language_Code = "hi-IN";

  Future<void> translateText(String text, String target_language_code) async {
    var url = Uri.parse('https://api.sarvam.ai/translate');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'api-subscription-key': '82762314-dc16-44a1-8ed8-ddb06d32e316',
      },
      body: jsonEncode({
        "input": text ?? "", // Ensure text is not null
        "source_language_code": "en-IN",
        "target_language_code": language_Code,
        "speaker_gender": "Male",
        "mode": "formal",
        "model": "mayura:v1",
        "enable_preprocessing": true
      }),
    );

    if (response.statusCode == 200) {
      // Decode the response ensuring UTF-8 handling
      var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

      print('Translation passed with status: ${response.statusCode}  && ${jsonResponse}');
      setState(() {
        translatedText = jsonResponse['translated_text'] ?? 'Translation unavailable';
      });
    } else {
      print('Translation failed with status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate The Course '),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _translationController,
              maxLines: 5,
              decoration: InputDecoration(hintText: 'Enter course content'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
               // TextField(controller: textController),
              DropdownButton<String>(
              value: language_Code,
              items: <String>[
                'hi-IN', 'bn-IN', 'kn-IN', 'ml-IN', 'mr-IN', 'od-IN',
                'pa-IN', 'ta-IN', 'te-IN', 'gu-IN', 'en-IN'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  language_Code = newValue!;
                });
              },
            ),

                ElevatedButton(
                onPressed: () => translateText(_translationController.text, 'te'),
                  child: Text("Translate the Content"),
                ),
                SizedBox(width: 16),

              ],
            ),
            SizedBox(height: 16),
            Text('Translated Text: $translatedText'),

          ],
        ),
      ),




    );
  }


}

