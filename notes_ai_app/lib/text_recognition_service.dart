import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

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