// Copyright (c) 2017, Matthew. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library phash;

import 'package:image/image.dart';

class ImageHash  {
  final List<int> _hash;

  int get length => _hash.length;

  ImageHash(this._hash);

  ImageHash.parse(String hash): _hash= <int>[] {
    for(int i = 0; i <hash.length; i += 2) {
      String hexDigit  = hash.substring(i, i+2);
      int digit = int.parse(hexDigit, radix: 16);
      String binaryString = digit.toRadixString(2).padLeft(8,'0');
      for(int j = 0; j < binaryString.length; j++) {
        _hash.add(int.parse(binaryString.substring(j,j+1)));
      }
    }
  }

  ImageHash.forImage(Image sourceImage, {int size: 8}): _hash= <int>[] {
    if(((size*size)%4)!=0)
      throw new ArgumentError("size's square must be divisible by 4");

    List<List<int>> pixels = <List<int>>[];

    int pixelColorTotal = 0;

    Image image = copyResize(sourceImage, size, size, AVERAGE);

    for(int x = 0; x<image.width; x++) {
      pixels.add(<int>[]);
      for(int y = 0; y < image.height; y++) {


        // TODO: implement rotational logic
        /*
			// instead of rotating the image, we'll rotate the position of the pixels to allow us to generate a hash
			// we can use to judge if one image is a rotated or flipped version of the other, without actually creating
			// an extra image resource. This currently only works at all for 90 degree rotations and mirrors.
			*/
//    switch(rot){
//      case 90:	rx=((size-1)-y);	ry=x;			break;
//      case 180:	rx=(size-x)-1;		ry=(size-1)-y;	break;
//      case 270:	rx=y;				ry=(size-x)-1;	break;
//      default:	rx=x;				ry=y;			break;
//    }
//    switch(mir){
//      case 1: rx = ((size-rx)-1); break;
//      case 2: ry = (size-ry); 	break;
//      case 3: rx = ((size-rx)-1);
//      ry = (size-ry); 	break;
//      default: 					break;
//    }

        int pixel = image.getPixel(x, y);
        int r = getRed(pixel);
        int g = getGreen(pixel);
        int b = getBlue(pixel);


        /* pseudo-desaturate (run the code on the data but don't actually affect the image)
			r = ($rgb >> 16) & 0xFF;
			g = ($rgb >> 8) & 0xFF;
			b = $rgb & 0xFF;
			*/
        int gs = ((r*0.299)+(g*0.587)+(b*0.114)).floor();
        pixels[x].add(gs);
        pixelColorTotal += gs;
      }


    }

    int avg = (pixelColorTotal/(image.height*image.width)).floor();

    for(int x = 0; x < pixels.length; x++) {
      for(int y = 0; y < pixels[x].length; y++) {
        int px = pixels[x][y];
        if(px>avg) {
          _hash.add(1);
        } else {
          _hash.add(0);
        }
      }
    }
  }

  double compareTo(ImageHash other) {
    if(this._hash.length!=other._hash.length)
      throw new ArgumentError("Image hash sizes must be the same in order to compare");

    int similarity = _hash.length;
    for(int i = 0; i < other._hash.length; i++) {
      if(_hash[i]!=other._hash[i]) {
        similarity--;
      }
    }

    double percentage = (similarity/_hash.length*100);
    return percentage;
  }

  @override
  String toString() {
    final StringBuffer buffer = new StringBuffer();
    final StringBuffer outputBuffer = new StringBuffer();

    for(int i =0; i< _hash.length; i++) {
      if(i>3&&i%4==0) {
        int digit = int.parse(buffer.toString(), radix: 2);
        outputBuffer.write(digit.toRadixString(16));
        buffer.clear();
      }
      buffer.write(_hash[i]);
    }
    int digit = int.parse(buffer.toString(), radix: 2);
    outputBuffer.write(digit.toRadixString(16));
    return outputBuffer.toString();
  }
}




