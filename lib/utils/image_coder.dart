import 'dart:typed_data';
import 'dart:ui';

Future<List<String>?> encodeImage(Image image) => 
    ImageEncoder.encodeImage(image);

Future<Image?> decodeImage(List<String> stringList) =>
    ImageDecoder.decodeImage(stringList);

class ImageEncoder {
  static Future<List<String>?> encodeImage(Image image) async {
    //Trying to get bytes
    ByteData? bytes;
    try {
      final bytes = await image.toByteData(
          format: ImageByteFormat.png);
      if (bytes == null) {
        throw Exception();
      }
    } on Exception {
      //Return null on fail
      return null;
    }
    //Turn into uInt8List on success
    var uInt8List = bytes!.buffer.asUint8List();
    //Turn into StringList
    List<String> stringList = [];
    for (var element in uInt8List) {
      stringList.add(element.toString());
    }

    return stringList;
  }
}
class ImageDecoder {
  static Future<Image?> decodeImage(List<String> stringList) async {
    List<int> intList = [];
    for (var element in stringList) {
      try {
        intList.add(int.parse(element));
      } on FormatException {
        return null;
      }
    }
    //Get Image
    var bytes = Uint8List.fromList(intList);
    final codec = await instantiateImageCodec(bytes);
    final frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}