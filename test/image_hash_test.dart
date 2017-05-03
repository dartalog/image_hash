// Copyright (c) 2017, Matthew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:image/image.dart';
import 'package:image_hash/image_hash.dart';
import 'package:test/test.dart';

Image loadImage(String path) {
  File f = new File(path);
  final List<int> data = f.readAsBytesSync();
  return decodeJpg(data);
}

void main() {
  Image image1;


  setUp(() {
    image1 = loadImage("test/monalisa.jpg");
  });

  group("ImageHash",() {
    test(".forImage()", () {
      final ImageHash hash = new ImageHash.forImage(image1);
      expect(hash, isNotNull);
      expect(hash.toString(), "c0c0c2faf8c0e0f0");
    });
  });

  group('Compare images', () {
    ImageHash hash;

    setUp(() {
      hash = new ImageHash.forImage(image1);
    });

    test('Compare resized image', () {
      final Image image2 = copyResize(image1, (image1.width/2).floor());
      final ImageHash hash2 = new ImageHash.forImage(image2);
      expect(hash2.toString(), "c0c0c2faf8c0e0f0");
      double result = hash.compareTo(hash2);
      expect(result, 100);
    });

    test('Compare rotated image', () {
      final Image image2 = copyRotate(image1, 90);
      final ImageHash hash2 = new ImageHash.forImage(image2);
      expect(hash2.toString(), "00300018191bffff");
      double result = hash.compareTo(hash2);
      expect(result, 50);
    });

    test('Compare flipped image', () {
      final Image image2 = copyRotate(image1, 180);
      final ImageHash hash2 = new ImageHash.forImage(image2);
      expect(hash2.toString(), "0f07031b5f430303");
      double result = hash.compareTo(hash2);
      expect(result, 42.1875);
    });

    test('Compare copped image', () {
      final Image image2 = copyRotate(image1, 180);
      final ImageHash hash2 = new ImageHash.forImage(image2);
      expect(hash2.toString(), "0f07031b5f430303");
      double result = hash.compareTo(hash2);
      expect(result, 42.1875);
    });

    test('Compare flipped image', () {
      final Image image2 = loadImage("test/scenery.jpg");
      final ImageHash hash2 = new ImageHash.forImage(image2);
      expect(hash2.toString(), "e1e1c0c0c0f8f163");
      double result = hash.compareTo(hash2);
      expect(result, 67.1875);
    });

  });
}
