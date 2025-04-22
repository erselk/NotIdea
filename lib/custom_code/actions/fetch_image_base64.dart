// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> fetchImageBase64(String userInput) async {
  final url =
      "https://image.pollinations.ai/prompt/$userInput?model=turbo&width=512&height=512&nologo=true";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Handle raw binary data
      Uint8List imageData = response.bodyBytes;

      // Convert image data to Base64
      String base64Image = base64Encode(imageData);

      // Create HTML string with Base64 image data
      final String htmlString = '''
      <html>
        <head>
          <style>
            /* Disable scrolling in WebView */
            body, html {
              margin: 0;
              padding: 0;
              overflow: hidden; /* Disables scroll */
              height: 100%;
            }
            /* Make sure the image fits the WebView size */
            img {
              width: 100%;
              height: 100%;
              object-fit: contain; /* Ensures the image maintains aspect ratio */
            }
          </style>
        </head>
        <body>
          <img src="data:image/png;base64,$base64Image" alt="Image" />
        </body>
      </html>
      ''';

      return htmlString; // Return the HTML string with embedded Base64 image
    } else {
      print("Failed to load image: ${response.statusCode}");
      return null; // Return null if image fetching fails
    }
  } catch (e) {
    print("Error fetching image: $e");
    return null; // Return null if there's an error
  }
}
