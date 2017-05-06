import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:image/image.dart';
import 'package:image_hash/image_hash.dart';

Future<Null> main(List<String> args) async {
  File f1 = new File(args[0]);
  File f2 = new File(args[1]);

  List<int> data1 =f1.readAsBytesSync();
  List<int> data2 =f2.readAsBytesSync();

  Image i1 = decodeImage(data1);
  Image i2 = decodeImage(data2);
  
  ImageHash hash1 = new ImageHash.forImage(i1);
  ImageHash hash2 = new ImageHash.forImage(i2);

  double result = hash1.compareTo(hash2);


  print("Image 1 perceptual hash: ${hash1.toString()}");
  print("Image 2 perceptual hash: ${hash2.toString()}");
  print("Comparison result: $result");
}
