import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class RecognitionApi {
  static Future<String?> recogniseText(InputImage inputImage) async {
    try {
      final textRecogniser = TextRecognizer();

      final recognisedImage = await textRecogniser.processImage(inputImage);

      return recognisedImage.text;
    } catch (e) {
      return null;
    }
  }
}
