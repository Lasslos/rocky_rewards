import 'dart:typed_data';
import 'dart:ui';

Future<Uint8List?> encodeImage(Image image) =>
    ImageEncoder.encodeImage(image);

Future<Image?> decodeImage(Uint8List bytes) =>
    ImageDecoder.decodeImage(bytes);

class ImageEncoder {
  static Future<Uint8List?> encodeImage(Image image) async {
    //Trying to get bytes
    ByteData bytes;
    try {
      bytes = (await image.toByteData(
          format: ImageByteFormat.png))!;
    } on Exception {
      //Return null when conversion throws error or returns null
      return null;
    }

    //Turn into uInt8List on success
    return bytes.buffer.asUint8List();
  }
}
class ImageDecoder {
  static Future<Image?> decodeImage(Uint8List bytes) async {
    final codec = await instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}