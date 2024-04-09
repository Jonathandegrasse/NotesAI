import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  // Access the API key
  final String apiKey = dotenv.env['API_KEY']!;
  print("API key: $apiKey");
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
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      controller = CameraController(widget.cameras[0], ResolutionPreset.high);
      await controller.initialize();
      if (!mounted) return;
      setState(() => isCameraInitialized = true);
    } else {
      print('No camera is available');
    }
  }

  Future<void> _takePicture() async {
    if (!controller.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile image = await controller.takePicture();
      print("Picture saved to ${image.path}");

      // Analyze the captured image for text
      final detectedText = await recognizeText(image.path);
      print("Detected text: $detectedText");

      // Display the detected text or use it as needed

      // Save image to the computer
      await _saveImageToComputer(image.path);
    } catch (e) {
      print(e); // If an error occurs, log the error
    }
  }

  Future<String> recognizeText(String imagePath) async {
    // Replace `YOUR_API_KEY` with your actual Cloud Vision API key
    final String apiKey = "YOUR_API_KEY";
    final String url = "https://vision.googleapis.com/v1/images:annotate?key=$apiKey";

    // Convert image to base64
    final bytes = await File(imagePath).readAsBytes();
    final base64Image = base64Encode(bytes);

    // Construct the API request
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [{"type": "TEXT_DETECTION"}]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      // Extracting the detected text from the API response
      final text = responseJson['responses'][0]['fullTextAnnotation']['text'];
      return text;
    } else {
      throw Exception('Failed to recognize text.');
    }
  }

  Future<void> _saveImageToComputer(String imagePath) async {
    try {
      final File originalImageFile = File(imagePath);
      final String directoryPath = "/path/to/your/directory";
      final String copyPath = path.join(directoryPath, path.basename(imagePath));
      await originalImageFile.copy(copyPath);
      print("Image saved to $copyPath");
    } catch (e) {
      print("Failed to save image: $e");
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
      child: isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(controller),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    child: Icon(Icons.camera_alt),
                    onPressed: _takePicture,
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}