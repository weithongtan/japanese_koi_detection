import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class YoloVideo extends StatefulWidget {
  const YoloVideo({super.key});

  @override
  State<YoloVideo> createState() => _YoloVideoState();
}

class _YoloVideoState extends State<YoloVideo> {
  late List<CameraDescription> cameras;
  late CameraController controller;
  late FlutterVision vision;
  late List<Map<String, dynamic>> yoloResults;

  CameraImage? cameraImage;
  bool isLoaded = false;
  bool isDetecting = false;
  double confidenceThreshold = 0.5;
  var cameraCount = 0;

  @override
  void dispose() {
    _disposeResources();
    super.dispose();
  }

  Future<void> _disposeResources() async {
    try {
      if (controller.value.isStreamingImages) {
        await controller.stopImageStream();
      }
      await controller.dispose();
      await vision.closeYoloModel();
    } catch (e) {
      print("Error disposing resources: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    try {
      if (await Permission.camera.request().isGranted) {
        cameras = await availableCameras();
        vision = FlutterVision();

        controller = CameraController(
          cameras[0],
          ResolutionPreset.high,
          imageFormatGroup: ImageFormatGroup.yuv420,
        );

        await controller.initialize();
        await loadYoloModel();
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      } else {
        print("Permission denied");
      }
    } catch (e) {
      print("Error during initialization: $e");
    }
  }

  Future<void> loadYoloModel() async {
    try {
      await vision.loadYoloModel(
          modelPath: "lib/koi_fish_model/type/yolo_type.tflite",
          labels: "lib/koi_fish_model/type/yolo_type.txt",
          modelVersion: "yolov8",
          numThreads: 1,
          useGpu: false);
      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      print("Error loading YOLO model: $e");
    }
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    try {
      final result = await vision.yoloOnFrame(
          bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
          imageHeight: cameraImage.height,
          imageWidth: cameraImage.width,
          iouThreshold: 0.4,
          confThreshold: 0.4,
          classThreshold: 0.5);
      if (result.isNotEmpty) {
        setState(() {
          yoloResults = result;
        });
      }
    } catch (e) {
      print("Error during YOLO frame processing: $e");
    }
  }

  Future<void> startDetection() async {
    if (isDetecting || controller.value.isStreamingImages) {
      return; // Prevent multiple starts
    }
    setState(() {
      isDetecting = true;
    });
    await controller.startImageStream((image) async {
      if (!isDetecting || !mounted) {
        return; // Safety checks
      }
      cameraCount++;
      if (cameraCount % 10 == 0) {
        cameraCount = 0;
        cameraImage = image;
        try {
          await yoloOnFrame(image);
        } catch (e) {
          print("Error during frame processing: $e");
        }
      }
    });
  }

  Future<void> stopDetection() async {
    if (!isDetecting) return; // Prevent multiple stops
    setState(() {
      isDetecting = false;
    });
    try {
      await controller.stopImageStream();
    } catch (e) {
      print("Error stopping image stream: $e");
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];
    double factorX = screen.width / (cameraImage?.height ?? 1);
    double factorY = screen.height / (cameraImage?.width ?? 1);

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      double objectX = result["box"][0] * factorX;
      double objectY = result["box"][1] * factorY;
      double objectWidth = (result["box"][2] - result["box"][0]) * factorX;
      double objectHeight = (result["box"][3] - result["box"][1]) * factorY;

      return Positioned(
        left: objectX,
        top: objectY,
        width: objectWidth,
        height: objectHeight,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(2)}%",
                style: TextStyle(
                  background: Paint()..color = colorPick,
                  color: const Color.fromARGB(255, 115, 0, 255),
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // void _showMoreInfo(Map<String, dynamic> result) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Information about ${result['tag']}'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Confidence: ${(result['box'][4] * 100).toStringAsFixed(2)}%'),
  //               Text('Position: (${result['box'][0].toStringAsFixed(2)}, ${result['box'][1].toStringAsFixed(2)})'),
  //               Text('Size: ${(result['box'][2] - result['box'][0]).toStringAsFixed(2)} x ${(result['box'][3] - result['box'][1]).toStringAsFixed(2)}'),
  //               // Add more information here as needed
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: const Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(
              controller,
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
          Positioned(
            bottom: 75,
            width: MediaQuery.of(context).size.width,
            child: Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 5, color: Colors.white, style: BorderStyle.solid),
              ),
              child: isDetecting
                  ? IconButton(
                      onPressed: () async {
                        stopDetection();
                      },
                      icon: const Icon(
                        Icons.stop,
                        color: Colors.red,
                      ),
                      iconSize: 50,
                    )
                  : IconButton(
                      onPressed: () async {
                        await startDetection();
                      },
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                      iconSize: 50,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
