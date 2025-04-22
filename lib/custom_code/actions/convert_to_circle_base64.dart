// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

Future<String> convertToCircleBase64(FFUploadedFile? imagePath) async {
  // Check if imagePath is null or if file bytes are null
  if (imagePath == null || imagePath.bytes == null) {
    return ''; // Return empty string if no valid bytes
  }

  try {
    // Get bytes from FFUploadedFile
    final Uint8List imageBytes = Uint8List.fromList(imagePath.bytes!);

    // Decode image to get dimensions
    final ui.Image originalImage = await decodeImageFromList(imageBytes);
    final int imageWidth = originalImage.width;
    final int imageHeight = originalImage.height;

    // Create a canvas with a square size based on the shortest dimension
    final int canvasSize = imageWidth < imageHeight ? imageWidth : imageHeight;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    // Draw a circular clipping path
    final Paint paint = Paint();
    final Path path = Path()
      ..addOval(
          Rect.fromLTWH(0, 0, canvasSize.toDouble(), canvasSize.toDouble()))
      ..close();
    canvas.clipPath(path);

    // Center and draw the original image into the circular canvas
    final double dx = (canvasSize - imageWidth) / 2;
    final double dy = (canvasSize - imageHeight) / 2;
    canvas.drawImage(originalImage, Offset(dx, dy), paint);

    // Convert the canvas to an image
    final ui.Image circularImage =
        await recorder.endRecording().toImage(canvasSize, canvasSize);

    // Convert the circular image to PNG bytes
    final ByteData? pngBytes =
        await circularImage.toByteData(format: ui.ImageByteFormat.png);

    if (pngBytes == null) {
      return ''; // Return empty string if conversion fails
    }

    // Convert bytes to Base64 string
    final String base64Image = base64Encode(pngBytes.buffer.asUint8List());

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
        <img src="data:image/png;base64,$base64Image" alt="Circular Image" />
      </body>
    </html>
    ''';

    // Return the HTML string
    return htmlString;
  } catch (e) {
    // Handle errors gracefully
    print('Error converting to circular Base64: $e');
    return ''; // Return empty string in case of error
  }
}
