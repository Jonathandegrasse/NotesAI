import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraWidget({required this.cameras});

  @override
  _CameraWidgetState createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isNotEmpty) {
      _controller = CameraController(widget.cameras[0], ResolutionPreset.medium);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isCameraInitialized = true;
        });
      }).catchError((e) {
        print(e); // Handle the error properly in a production app
      });
    } else {
      print('No camera is available');
    }
  }

  Future<void> _takePicture() async {
    if (!_controller.value.isInitialized) {
      print('Error: select a camera first.');
      return;
    }

    if (_controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return;
    }

    try {
      final XFile image = await _controller.takePicture();
      print("Picture saved to ${image.path}");
      // Here, you can add code to display the image or save it to the gallery
    } catch (e) {
      print(e); // If an error occurs, log the error
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_controller), // Display the camera preview
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    child: Icon(Icons.camera),
                    onPressed: _takePicture, // Capture the image when the button is pressed
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()), // Show a loading indicator until the camera is initialized
    );
  }
}