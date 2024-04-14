import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_picker/gallery_picker.dart';
import 'package:gallery_picker/models/media_file.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? selectedMedia;
  String recognizedText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "NotesAI",
        ),
      ),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<MediaFile>? media = await GalleryPicker.pickMedia(
              context: context, singleMedia: true);
          if (media != null && media.isNotEmpty) {
            var data = await media.first.getFile();
            setState(() {
              selectedMedia = data;
            });
          }
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  Widget _buildUI() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _imageView(),
        _extractTextView(),
      ],
    );
  }

  Widget _imageView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("Pick an image for text recognition."),
      );
    }
    return Center(
      child: Image.file(
        selectedMedia!,
        width: 200,
      ),
    );
  }

  Widget _extractTextView() {
    if (selectedMedia == null) {
      return const Center(
        child: Text("No result."),
      );
    }
    return FutureBuilder(
      future: _extractText(selectedMedia!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          recognizedText = snapshot.data ?? "";
          List<String> words = recognizedText.split(RegExp(r'\b'));
          return Wrap(
            spacing: 8.0, // Horizontal space between words
            runSpacing: 4.0, // Vertical space between lines
            children: words
                .where((word) => word.trim().isNotEmpty)
                .map((word) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlashcardScreen(
                                word: word, definition: "Definition of $word"),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Text(word, style: TextStyle(fontSize: 18)),
                      ),
                    ))
                .toList(),
          );
        } else {
          return const SizedBox(); // Return an empty container by default
        }
      },
    );
  }

  Future<String?> _extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    return text;
  }
}

class FlashcardScreen extends StatefulWidget {
  final String word;
  final String definition;

  const FlashcardScreen({required this.word, required this.definition});

  @override
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  String? definition;

  @override
  void initState() {
    super.initState();
    _fetchDefinition();
  }

  Future<void> _fetchDefinition() async {
    final String? def = await _getDefinition(widget.word);
    setState(() {
      definition = def;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.word),
      ),
      body: Center(
        child: definition != null
            ? Text(definition!)
            : CircularProgressIndicator(),
      ),
    );
  }
}

Future<String?> _getDefinition(String word) async {
  final apiKey =
      '66df304a-8f7e-4604-ac7d-b54a27424ff1'; // Replace with your Merriam-Webster API key
  final url = Uri.parse(
      'https://www.dictionaryapi.com/api/v3/references/collegiate/json/$word?key=$apiKey');

  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        final firstEntry = data.first;
        if (firstEntry['shortdef'] != null &&
            firstEntry['shortdef'] is List<dynamic>) {
          final List<dynamic> definitions = firstEntry['shortdef'];
          if (definitions.isNotEmpty) {
            return definitions.first;
          }
        }
      }
    }
  } catch (e) {
    print('Error fetching definition: $e');
  }
  return null;
}
