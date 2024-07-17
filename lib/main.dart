// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:orc_mlkit_flutter/camera_widget.dart';
import 'package:orc_mlkit_flutter/providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final availableCamera = ref.watch(availableCamerasProvider);

          return availableCamera.when(
            data: (data) {
              final _cameraDescription = data.first;
              return CameraWidget(camera: _cameraDescription);
            },
            error: (error, stackTrace) {
              return Center(
                child: Text("Error: ${error.toString()} "),
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            },
          );
        },
      ),
    );
  }
}
