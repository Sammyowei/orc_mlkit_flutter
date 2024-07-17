import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:orc_mlkit_flutter/apis/recognition_api.dart';
import 'package:orc_mlkit_flutter/providers/providers.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({super.key, required this.camera});

  final CameraDescription camera;

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  late CameraController _cameraController;

  late Future<void> initCameraFn;

  String? shownText;
  @override
  void initState() {
    super.initState();

    _cameraController = CameraController(widget.camera, ResolutionPreset.max);

    initCameraFn = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        FutureBuilder(
          future: initCameraFn,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            return SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: CameraPreview(_cameraController),
            );
          },
        ),
        Positioned(
          bottom: 50,
          child: Consumer(builder: (context, ref, _) {
            return FloatingActionButton(
              onPressed: () async {
                ref.read(loadingStateProvider.notifier).toggle();
                final image = await _cameraController.takePicture();

                print("New Image path:" + image.path);
                final recognisedText = await RecognitionApi.recogniseText(
                    InputImage.fromFile(File(image.path)));
                // setState(() {
                //   shownText = recognisedText;
                //   print(shownText);
                // });

                if (recognisedText != null) {
                  ref.read(loadingStateProvider.notifier).toggle();
                  ref
                      .read(textNotifierProvider.notifier)
                      .setState(recognisedText);
                  if (context.mounted) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Consumer(
                          builder: (context, ref, child) {
                            final text = ref.watch(textNotifierProvider);
                            return Align(
                              alignment: Alignment.center,
                              child: Container(
                                color: Colors.black45,
                                child: Text(
                                  text,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                }

                ref.read(loadingStateProvider.notifier).toggle();
              },
              child: const Icon(Icons.camera),
            );
          }),
        ),
        Align(
          alignment: Alignment.center,
          child: Consumer(
            builder: (context, ref, child) {
              final isLoading = ref.watch(loadingStateProvider);
              return Visibility(
                visible: isLoading,
                child: const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
