import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class Flashcard {
  String term;
  String definition;

  Flashcard({required this.term, required this.definition});
}

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkModeEnabled = false;
  bool isAutoSaveEnabled = true;
  bool isTextToSpeechEnabled = false;
  bool isCameraAIEnabled = true;
  bool isCloudSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: isDarkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                isDarkModeEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Auto-Save'),
            value: isAutoSaveEnabled,
            onChanged: (bool value) {
              setState(() {
                isAutoSaveEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Text-to-Speech'),
            value: isTextToSpeechEnabled,
            onChanged: (bool value) {
              setState(() {
                isTextToSpeechEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Notifications'),
            value: isCameraAIEnabled,
            onChanged: (bool value) {
              setState(() {
                isCameraAIEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: Text('Auto Sync'),
            value: isCloudSyncEnabled,
            onChanged: (bool value) {
              setState(() {
                isCloudSyncEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class FlashcardsScreen extends StatefulWidget {
  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<CameraDescription> cameras;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
    });
  }

  void _showCamera() async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return CameraWidget(cameras: cameras);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NotesAI'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Text('Menu'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _showCamera();
              },
            ),
            ListTile(
              title: Text('Notes'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Notes
              },
            ),
            ListTile(
              title: Text('Flashcards'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlashcardsScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Archived Flashcards'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to Archived Flashcards
              },
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Welcome to NotesAI"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt, size: 40),
        onPressed: _showCamera,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class CameraWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraWidget({required this.cameras});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController controller;
  bool isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.cameras.isNotEmpty) {
      controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() => isCameraInitialized = true);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: isCameraInitialized ? CameraPreview(controller) : Center(child: CircularProgressIndicator()),
    );
  }
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<Flashcard> flashcards = [
    Flashcard(
      term: "Human Factors",
      definition: "Human factors (HF) is the study of how people use technology. "
          "It involves the interaction of human abilities, expectations, and limitations, "
          "with work environments and system design. The term 'human factors engineering' "
          "(HFE) refers to the application of human factors principles to the design of devices and systems.",
    ),
    // Add more flashcards here
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcards'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (flashcards.isNotEmpty)
            FlipFlashcard(
              term: flashcards[currentIndex].term,
              definition: flashcards[currentIndex].definition,
            ),
          SizedBox(height: 50),
          ElevatedButton(
            child: Text('Next'),
            onPressed: () {
              setState(() {
                if (currentIndex < flashcards.length - 1) {
                  currentIndex++;
                } else {
                  currentIndex = 0; // Loop back to the first flashcard
                }
              });
            },
          ),
        ],
      ),
    );
  }
}


class FlipFlashcard extends StatefulWidget {
  final String term;
  final String definition;

  FlipFlashcard({required this.term, required this.definition});

  @override
  _FlipFlashcardState createState() => _FlipFlashcardState();
}

class _FlipFlashcardState extends State<FlipFlashcard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
          isFront = !isFront;
        }
      });
  }

  void _flipCard() {
    if (_controller.isAnimating) {
      return;
    }

    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Set the card's width to the full width of the screen
    final double cardWidth = screenWidth;

    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (BuildContext context, Widget? child) {
          // Interpolating the right angle for the animation
          final angle = _flipAnimation.value * pi;
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Add perspective
              ..rotateY(angle),
            child: isFront
                ? CardFrontView(term: widget.term, width: cardWidth)
                : CardBackView(definition: widget.definition, width: cardWidth),
          );
        },
      ),
    );
  }
}

Widget CardFrontView({required String term, required double width}) {
  return Container(
    width: width,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.blue,
      border: Border.all(color: Colors.black, width: 2.0),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Center(
      child: Text(
        term,
        style: TextStyle(fontSize: 24, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

Widget CardBackView({required String definition, required double width}) {
  return Transform(
    alignment: Alignment.center,
    transform: Matrix4.identity()..rotateY(pi), // Correct the mirrored effect
    child: Container(
      width: width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          definition,
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}