import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:koi_detection_flutter_app/AWS/s3bucket.dart';
import 'package:koi_detection_flutter_app/pages/home_default/chatbot.dart';
import 'package:koi_detection_flutter_app/pages/profile/result_screen.dart';
import 'package:koi_detection_flutter_app/utility/koi_decription.dart';
import 'package:koi_detection_flutter_app/utility/square_button.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image/image.dart' as img;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late File imagef;
  List priceOutput = [];
  List typeOutput = [];
  Map<String, int> koiTypeOrder = {
    "Asagi": 0,
    "Bekko": 1,
    "Hikarimoyomono": 2,
    "Hikarimuji": 3,
    "Kohaku": 4,
    "Koromo": 5,
    "Sanke": 6,
    "Showa": 7,
    "Shusui": 8,
    "Tancho": 9,
    "Utsurimono": 10,
    "other": 11
  };
  final picker = ImagePicker();
  bool loading = false;
  User? user = FirebaseAuth.instance.currentUser;

  FlutterVision vision = FlutterVision();

  @override
  Future<void> dispose() async {
    super.dispose();
    await vision.closeYoloModel();
  }

  classifyAndUploadImage(File image) async {
    await vision.loadYoloModel(
        labels: 'lib/koi_fish_model/type/yolo_type.txt',
        modelPath: 'lib/koi_fish_model/type/yolo_type.tflite',
        modelVersion: "yolov8",
        quantization: false,
        numThreads: 1,
        useGpu: false);

    Uint8List byte = await image.readAsBytes();
    img.Image? imageSize = img.decodeImage(byte);

    final typeResult = await vision.yoloOnImage(
        bytesList: byte,
        imageHeight: imageSize!.height,
        imageWidth: imageSize.width,
        iouThreshold: 0.8,
        confThreshold: 0.4,
        classThreshold: 0.7);

    setState(() {
      if (typeResult.isEmpty) {
        typeOutput = [];
      } else {
        typeOutput = typeResult;
      }
    });
    // Load the second model
    if (typeOutput.isNotEmpty) {
      await vision.loadYoloModel(
          labels: 'lib/koi_fish_model/price/price.txt',
          modelPath: 'lib/koi_fish_model/price/price.tflite',
          modelVersion: "yolov8",
          quantization: false,
          numThreads: 1,
          useGpu: false);


      // Run inference with the second model
      final priceResult = await vision.yoloOnImage(
          bytesList: byte,
          imageHeight: imageSize.height,
          imageWidth: imageSize.width,
          iouThreshold: 0.8,
          confThreshold: 0.4,
          classThreshold: 0.3);

      // Handle the results from both models
      setState(() {
        if (priceResult.isEmpty) {
          priceOutput = [];
        } else {
          priceOutput = priceResult;
        }
      });
    }

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);
  
    String koiType;
    String priceRange = "0";
    print(typeOutput);
    if (typeOutput.isEmpty) {
      koiType = "other";
    } else {
      koiType = typeOutput[0]['tag'];
      priceRange = priceOutput[0]['tag'];
    }

    int orderInDummy = koiTypeOrder[koiType]!;

    await S3Bucket.uploadImage(imagef, koiType,
        priceRange, user!.email, formattedDate);


    // Navigate to the ResultScreen with the results
    setState(() {
      loading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          img: image,
          koiType: koiType,
          description: Dummy.koiType[orderInDummy]["description"],
          title: Dummy.koiType[orderInDummy]['title'],
          priceRange: koiType != "other" ? priceRange : "0",
          creationDate: formattedDate,
        ),
      ),
    );
  }

  takePhoto() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      loading = true;
      imagef = File(image.path);
    });

    classifyAndUploadImage(imagef);
  }

  pickGalleryImage() async {
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      loading = true;
      imagef = File(image.path);
    });

    classifyAndUploadImage(imagef);
  }

  Future<bool> _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            children: [
              SizedBox(
                width:
                    MediaQuery.of(context).size.width, // Adjust width as needed
                height: 400, //
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        height: 400,
                        width: MediaQuery.of(context).size.width *
                            0.6, // Adjust the width as needed
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'lib/asset/images/others/koi_theme.jpg'),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Home",
                            style: GoogleFonts.maShanZheng(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "Japanese Koi \nDetection",
                            style: GoogleFonts.maShanZheng(
                                color: Colors.white, fontSize: 40),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    SquareButton(
                      text: 'Choose from gallery',
                      func: pickGalleryImage,
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SquareButton(
                      text: 'Take a photo',
                      func: takePhoto,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                  onTap: () async {
                    bool isConnected = await _checkInternetConnection();
                    if (isConnected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChatBot(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'No internet connection. Please try again later.')),
                      );
                    }
                  },
                  child: Image.asset(
                    'lib/asset/images/others/chatbox_robot.gif', // Replace 'assets/animated.gif' with your GIF asset path
                    width: 70, // Adjust the width as needed
                    height: 70, // Adjust the height as needed
                    fit: BoxFit.cover, // Ensure the GIF fills the container
                  ),
                ),
              )
            ],
          );
  }
}
