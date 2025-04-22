// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:io';

Future<String> convertToBase64(FFUploadedFile? imagePath) async {
  // Check if imagePath is null or if file bytes are null
  if (imagePath == null || imagePath.bytes == null) {
    return ''; // Return empty string if no valid bytes
  }

  try {
    // Get bytes from FFUploadedFile
    final List<int> imageBytes = imagePath.bytes!;

    // Convert bytes to Base64 string
    final String base64Image = base64Encode(imageBytes);

    // Create HTML string with the Base64 encoded image
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

    // Return the HTML string
    return htmlString;
  } catch (e) {
    // Handle errors gracefully
    print('Error converting to Base64: $e');
    return ''; // Return empty string in case of error
  }
}
