import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final availableCamerasProvider =
    FutureProvider<List<CameraDescription>>((ref) async {
  return availableCameras();
});
