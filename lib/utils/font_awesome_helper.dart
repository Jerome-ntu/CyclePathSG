import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Future<BitmapDescriptor> getFontAwesomeBitmap(IconData icon,
    {double size = 64, Color color = Colors.red}) async {
  final pictureRecorder = ui.PictureRecorder();
  final canvas = Canvas(pictureRecorder);
  final textPainter = TextPainter(textDirection: TextDirection.ltr);

  // Use icon.codePoint and icon.fontFamily
  textPainter.text = TextSpan(
    text: String.fromCharCode(icon.codePoint),
    style: TextStyle(
      fontSize: size,
      fontFamily: icon.fontFamily,
      package: icon.fontPackage, // important for Font Awesome
      color: color,
    ),
  );

  textPainter.layout();
  textPainter.paint(canvas, Offset(0, 0));

  final picture = pictureRecorder.endRecording();
  final img = await picture.toImage(size.toInt(), size.toInt());
  final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}
