import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class KoiCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String description;

  const KoiCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.description,
  });

  @override
  State<KoiCard> createState() => _KoiCardState();
}

class _KoiCardState extends State<KoiCard> {
  late final FlutterVision vision = FlutterVision();
  late File koiImage;
  late List typeOutput;
  final picker = ImagePicker();

  @override
  Future<void> dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  classifyKoi(File koiImage, String currentKoi) async {
    await vision.loadYoloModel(
        labels: 'lib/koi_fish_model/type/yolo_type.txt',
        modelPath: 'lib/koi_fish_model/type/yolo_type.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false);

    Uint8List byte = await koiImage.readAsBytes();
    img.Image? imageSize = img.decodeImage(byte);

    final typeResult = await vision.yoloOnImage(
        bytesList: byte,
        imageHeight: imageSize!.height,
        imageWidth: imageSize.width,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.7);

    setState(() {
      print(typeResult);
      typeOutput = typeResult;
    });

    String koiType;

    koiType = typeOutput.isEmpty ? "Empty" : typeOutput[0]['tag'];

    // closeLoadingDialog(context);

    _resultDialog(koiType, currentKoi, koiImage);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      koiImage = File(image.path);
    });
    // showLoadingDialog(context);

    classifyKoi(koiImage, widget.name);
  }

  takePhoto() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      koiImage = File(image.path);
    });

    // showLoadingDialog(context);

    classifyKoi(koiImage, widget.name);
  }

  Future<void> _resultDialog(
      String koiResult, String currentKoi, File koiImage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.file(
                  koiImage,
                  fit: BoxFit.contain,
                  height: 200,
                ),
                koiResult == "Empty"
                    ? const Text(
                        "The Koi Type is not available in the model or there are no koi in the image")
                    : currentKoi == koiResult
                        ? Text("Yes, the koi type in the image is $currentKoi")
                        : Text("The image shown is $koiResult not $currentKoi")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // void showLoadingDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     barrierDismissible:
  //         false, // Prevents dismissing the dialog by tapping outside
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(10.0),
  //         ),
  //         child: const Padding(
  //           padding: EdgeInsets.all(20.0),
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               CircularProgressIndicator(),
  //               SizedBox(width: 20),
  //               Text("Loading..."),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

// Function to close the dialog
  // void closeLoadingDialog(BuildContext context) {
  //   Navigator.pop(context); // Closes the dialog
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(175, 255, 255, 255),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    widget.imageUrl,
                    width: 100,
                    height: 160,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              pickGalleryImage();
                            },
                            child: const Icon(
                              Icons.image_outlined,
                              size: 35,
                            )),
                        GestureDetector(
                            onTap: () {
                              takePhoto();
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 35,
                            )),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
