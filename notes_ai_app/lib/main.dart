import 'package:flutter/material.dart';
import 'settings_screen.dart'; // Import the Settings screen
import 'flashcards_screen.dart'; // Import the Flashcards screen
import 'camera_widget.dart'; // Import the Camera widget
import 'package:camera/camera.dart'; // Import camera package
import 'package:flutter_config/flutter_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
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