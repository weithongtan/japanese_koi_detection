import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:koi_detection_flutter_app/utility/constant.dart';
import 'package:koi_detection_flutter_app/utility/general_function.dart';
import 'package:koi_detection_flutter_app/utility/price_range.dart';
import 'package:koi_detection_flutter_app/utility/read_more_text.dart';
import 'package:koi_detection_flutter_app/utility/result_image_related.dart';

class ResultScreen extends StatefulWidget {
  final dynamic img;
  final String koiType;
  final String title;
  final String description;
  final String priceRange;
  final String creationDate;

  const ResultScreen({
    super.key,
    required this.img,
    required this.koiType,
    required this.title,
    required this.description,
    required this.priceRange,
    required this.creationDate,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool isReadMore = false;

  final List<Map<String, dynamic>> _ranges = [
    {'label': '0', 'values': const RangeValues(0, 0)},
    {'label': '0-199', 'values': const RangeValues(0, 199)},
    {'label': '200-399', 'values': const RangeValues(200, 399)},
    {'label': '400-1000', 'values': const RangeValues(400, 999)},
    {'label': '1000-1999', 'values': const RangeValues(1000, 1999)},
    {'label': '2000', 'values': const RangeValues(2000, 2000)},
  ];

  // Function to get the RangeValues based on the selected label
  RangeValues getRangeValuesForLabel(String label) {
    Map<String, dynamic>? range =
        _ranges.firstWhere((range) => range['label'] == label);
    return range['values'];
  }

// Helper method to get the correct images for each koi type
  List<Widget> getKoiImageContainers(String koiType) {
    switch (koiType) {
      case 'Kohaku':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/kohaku/kohaku1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/kohaku/kohaku2.jpg'),
        ];
      case 'Showa':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/showa/showa1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/showa/showa2.jpg'),
        ];
      case 'Sanke':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/sanke/sanke1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/sanke/sanke2.jpg'),
        ];
      case 'Asagi':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/asagi1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/asagi2.jpg'),
        ];
      case 'Asagi':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/asagi1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/asagi2.jpg'),
        ];
      case 'Bekko':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/bekko1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/bekko2.jpg'),
        ];
      case 'Hikarimoyomono':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Hikarimoyomono1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Hikarimoyomono2.jpg'),
        ];
      case 'Hikarimuji':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Hikarimuji1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Hikarimuji2.jpg'),
        ];
      case 'Koromo':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Koromo1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Koromo2.jpg'),
        ];
      case 'Shusui':
        return [
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Shusui1.jpg'),
          const KoiImageContainer(
              koiImage: 'lib/asset/images/koi/Shusui2.jpg'),
        ];
      case 'other':
        return [const Center(child: Text("Not Found"))];
      default:
        return [const Text('No images available for this type')];
    }
  }

  @override
  Widget build(BuildContext context) {
    RangeValues selectedRangeValues = getRangeValuesForLabel(widget.priceRange);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('lib/asset/images/others/blur_bg.jpg'),
              fit: BoxFit.fill),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Image
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const ui.Color.fromARGB(255, 159, 159, 159),
                            width: 2.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: widget.img is File // Check if img is a File
                              ? Image.file(
                                  widget.img,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(widget.img as String),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    IntrinsicWidth(
                      child: Container(
                        color: const ui.Color.fromARGB(255, 255, 251, 230),
                        alignment: Alignment.centerRight,
                        margin: const EdgeInsets.only(right: 10),
                        child: Text(widget.creationDate),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    // Description
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadiusDirectional.vertical(
                          top: Radius.circular(20),
                        ),
                        color: ui.Color.fromARGB(255, 255, 251, 230),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style:
                                        normalText, // Default style for the entire text
                                    children: [
                                      TextSpan(
                                        text: GFunction.capitalizeFirstLetter(widget
                                            .koiType), // Text with different style
                                        style: const TextStyle(
                                          fontSize: 20,
                                          color: ui.Color.fromARGB(255, 0, 0,
                                              0), // Example style for "cdsc"
                                          fontWeight: FontWeight
                                              .bold, // Example style for "cdsc"
                                        ),
                                      ),
                                      TextSpan(
                                        text: widget
                                            .title, // Rest of the text with default style
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                            color: const ui.Color.fromARGB(255, 176, 212, 242),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GFunction.IconAndTitle("Estimate Price (RM)",
                                    const Icon(Icons.attach_money_outlined)),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('      0'), // Min value
                                    Text('2000+'), // Max value
                                  ],
                                ),
                                PriceRange(initialRange: selectedRangeValues),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                            color: const ui.Color.fromARGB(255, 176, 212, 242),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GFunction.IconAndTitle("Description",
                                    const Icon(Icons.description_outlined)),
                                const SizedBox(
                                  height: 20,
                                ),
                                ReadMoreText(text: widget.description),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                            color: const ui.Color.fromARGB(255, 176, 212, 242),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GFunction.IconAndTitle(
                                    "Images", const Icon(Icons.image_outlined)),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children:
                                      getKoiImageContainers(widget.koiType),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                    // Add additional content here
                  ],
                ),
              ),

              // Back Button alway stay on top left
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(146, 224, 224,
                        224), // Set the background color of the circle
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_sharp,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
