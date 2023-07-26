import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createIcon(int val) async{

  final PictureRecorder pictureRecorder = PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final paint = Paint();
  paint.color = (val == 0) ? Color(0xFF828577) : Color(0xFF373835);
  canvas.drawCircle(const Offset(20,20), 20, paint);
  canvas.drawRect(const Rect.fromLTWH(20, 0, 26, 40),paint);
  canvas.drawCircle(const Offset(46,20), 20, paint);
  //描画
  TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: val.toString(),
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 32,
      ),
    ),
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(minWidth: 0,maxWidth: 100);
  textPainter.paint(canvas, const Offset(34, 34));

  final image = await pictureRecorder.endRecording().toImage(100, 100);
  final data = await image.toByteData(format: ImageByteFormat.png);
  final Uint8List bytes = data!.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(bytes);

}