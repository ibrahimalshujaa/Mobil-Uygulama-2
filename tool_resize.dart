import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('assets/images/logo.png');
  if (!file.existsSync()) {
    print('Error: logo.png not found');
    return;
  }

  final imageBytes = file.readAsBytesSync();
  final image = img.decodeImage(imageBytes);
  if (image == null) {
    print('Error: could not decode image');
    return;
  }

  // Back up original just in case
  File('assets/images/logo_backup.png').writeAsBytesSync(imageBytes);

  // Background color at 0,0
  final bgColor = image.getPixel(0, 0);

  int minX = image.width;
  int minY = image.height;
  int maxX = 0;
  int maxY = 0;

  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final p = image.getPixel(x, y);
      final dr = (p.r - bgColor.r).abs();
      final dg = (p.g - bgColor.g).abs();
      final db = (p.b - bgColor.b).abs();
      
      // Threshold for artifact noise
      if (dr > 15 || dg > 15 || db > 15) {
        if (x < minX) minX = x;
        if (x > maxX) maxX = x;
        if (y < minY) minY = y;
        if (y > maxY) maxY = y;
      }
    }
  }

  if (minX > maxX || minY > maxY) {
    print('Error: could not find foreground object');
    return;
  }

  print('Original size: ${image.width}x${image.height}');
  print('Bounding box: $minX, $minY to $maxX, $maxY');

  final cropped = img.copyCrop(image, x: minX, y: minY, width: maxX - minX + 1, height: maxY - minY + 1);

  final int canvasSize = 1024;
  
  // The user wants 10-15% bigger. Let's set it to 75% of the new canvas (this usually makes it noticeably larger and perfectly centered).
  final double targetRatio = 0.75;
  int targetW = (canvasSize * targetRatio).toInt();
  int targetH = (canvasSize * targetRatio).toInt();
  
  if (cropped.width > cropped.height) {
    targetH = (targetW * cropped.height / cropped.width).round();
  } else {
    targetW = (targetH * cropped.width / cropped.height).round();
  }

  final resized = img.copyResize(cropped, width: targetW, height: targetH, interpolation: img.Interpolation.linear);

  final newImage = img.Image(width: canvasSize, height: canvasSize);
  
  // Fill background
  for (int y = 0; y < canvasSize; y++) {
    for (int x = 0; x < canvasSize; x++) {
      newImage.setPixel(x, y, bgColor);
    }
  }

  final int dstX = (canvasSize - targetW) ~/ 2;
  final int dstY = (canvasSize - targetH) ~/ 2;
  
  img.compositeImage(newImage, resized, dstX: dstX, dstY: dstY);

  file.writeAsBytesSync(img.encodePng(newImage));
  print('Successfully processed logo.png. New size: $canvasSize x $canvasSize');
}
