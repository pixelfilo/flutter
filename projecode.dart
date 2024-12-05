import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Assistant',
      theme: ThemeData(
        primaryColor: Color(0xFF000000), // Primary color (black)
        secondaryHeaderColor: Color(0xFFFBBC04), // Secondary color (yellow)
        backgroundColor: Color(0xFFF1F3F4), // Background color (light gray)
      ),
      home: VoiceAssistant(),
    );
  }
}

class VoiceAssistant extends StatefulWidget {
  @override
  _VoiceAssistantState createState() => _VoiceAssistantState();
}

class _VoiceAssistantState extends State<VoiceAssistant> {
  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _flutterTts = FlutterTts();
    _flutterTts.setLanguage("en-US");
    _flutterTts.setSpeechRate(0.5);
  }

  // Start listening to user's voice input
  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _text = 'Listening...';
      });
      _speech.listen(onResult: (result) {
        setState(() {
          _text = result.recognizedWords;
        });
        _performActionBasedOnCommand(result.recognizedWords);
      });
    } else {
      setState(() {
        _text = 'Speech recognition not available';
      });
    }
  }

  // Perform an action based on the voice command
  void _performActionBasedOnCommand(String command) {
    if (command.contains("play music")) {
      _flutterTts.speak("Playing music for you");
      // Here, you could add functionality to play music or trigger music APIs
    } else if (command.contains("call")) {
      _flutterTts.speak("Calling the contact");
      // Add functionality to initiate a call
    } else if (command.contains("open browser")) {
      _flutterTts.speak("Opening browser");
      // Add functionality to open a browser
    } else {
      _flutterTts.speak("Sorry, I didn't understand that");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Assistant'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_text',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startListening,
              child: Text('Start Listening'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFFBBC04), // Button color (yellow)
              ),
            ),
          ],
        ),
      ),
    );
  }
}
