import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:koi_detection_flutter_app/utility/constant.dart';
import 'package:koi_detection_flutter_app/utility/koi_card.dart';

class ExistingKoi extends StatefulWidget {
  const ExistingKoi({super.key});

  @override
  State<ExistingKoi> createState() => _ExistingKoiState();
}

class _ExistingKoiState extends State<ExistingKoi> {
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tips'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                    ),
                    Icon(
                      Icons.camera_alt_outlined,
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    text: 'Press to ', // Normal text
                    children: <TextSpan>[
                      TextSpan(
                        text: 'upload image', // Bold text
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' and ', // Normal text
                      ),
                      TextSpan(
                        text: 'take photo', // Bold text
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: " to detect either is the Koi Type or not")
                    ],
                  ),
                )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        backgroundColor: bgColor,
        title: Center(
          child: SizedBox(
            child: Column(
              children: [
                Text('Koi Classification',
                    style: GoogleFonts.maShanZheng(
                        color: Colors.white, fontSize: 50)),
                const SizedBox(
                  height: 20,
                ),
        
                    const Row(
                      children: [
                        Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                        ),
                        Icon(Icons.camera_alt_outlined, color: Colors.white),
                      ],
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        style: TextStyle(color: Colors.white, fontSize: 15),
                        TextSpan(
                          text: 'Press to ', // Normal text
                          children: <TextSpan>[
                            TextSpan(
                              text: 'upload image', // Bold text
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ' or ', // Normal text
                            ),
                            TextSpan(
                              text: 'take photo', // Bold text
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                                text:
                                    " to detect \nwhether is the Koi Type or not")
                          ],
                        ),
                      ),
                    ),
                 
                // Align(
                //   alignment: Alignment.centerRight,
                //   child: GestureDetector(
                //     onTap: _showMyDialog,
                //     child: Container(
                //       padding: const EdgeInsets.all(
                //           5), // Padding to keep the icon away from the border
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //           color: Colors.white, // Border color
                //           width: 2.0, // Border width
                //         ),
                //         color: Colors.transparent, // Transparent background
                //       ),
                //       child: const Icon(
                //         Icons.question_mark, // Your desired icon
                //         color: Colors.white, // Icon color
                //         size: 20, // Icon size
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
      backgroundColor: bgColor,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            KoiCard(
                imageUrl:
                    'https://www.kodamakoifarm.com/wp-content/uploads/2019/02/asagi-koi-135x200-v1.jpg',
                name: "Asagi",
                description:
                    "Asagi are characterized by 1) a blue or indigo body, and 2) red at the base of the pectoral fins. The red at the base of the pectoral fins is called Motoaka."),
            KoiCard(
              imageUrl:
                  'https://www.kodamakoifarm.com/wp-content/uploads/2018/03/Bekko.jpg',
              name: "Bekko",
              description:
                  "Bekko have only black and white colors in simple stepping stone pattern. There are no Hi (red) markings on this koi although it is bred from the Taisho Sanke koi.",
            ),
            KoiCard(
                imageUrl: 'https://valentinac.com/koi/images/ogon07.jpg',
                name: "Hikarimuji",
                description:
                    "Hikarimuji (hee-KAH-ree-MOO-gee) is a classification that incorporates metallic, single-colored koi, which can come with or without scale reticulation. The classification designation comes from “Hikari” meaning “shining” or “metallic” and “Muji”"),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2018/03/Kohaku.jpg",
                name: "Kohaku",
                description:
                    "It has been said that koi keeping begins and ends with Kohaku. In any variety that contains red patterns, it’s evaluated on an examination of its Kohaku pattern."),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2018/03/Koromo.jpg",
                name: "Koromo",
                description:
                    "Koromo are excellent koi and one to stand out. Koromo, means clothes or robe in Japanese and have a beautiful Hi (red) pattern of Kohaku on their pure white skin with an indigo blue pattern."),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2018/03/Showa.jpg",
                name: "Showa",
                description:
                    "Showa are beautiful koi, with colors of white, red, and black painted across their bodies. Showa are one of the Gosanke or “Big 3” koi fish along with Taisho Sanke and Kohaku koi. Before 1975, Showa were represented by the lineage of Kobayashi Showa."),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2019/02/shusui-koi-135x200-v1.jpg",
                name: "Shusui",
                description:
                    "Shusui was the first Doitsu variety of koi and are one of the only two blue koi! They are a Doitsu (scale-less) version of Asagi. Shusui was first bred in the early 1900’s by Yoshigoro Akiyama mixing the Doitsugio, a German scale fish, and the Asagi."),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2018/03/Taisho-Sanke.jpg",
                name: "Taisho Sanke",
                description:
                    "Taisho Sanke were developed from Kohaku about 80 years ago in 1918 in the era of Taisho. The Taisho Sanke, also called Taisho Sanshoku, pattern consists of three colors: white, red (Hi) and black (Sumi)."),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2019/02/tancho-koi-135x200-v1.jpg",
                name: "Tancho",
                description:
                    "Tancho are loved for many reasons including their resemblance to the Japanese flag and ability to stand out in a pond. They are named after the sacred red crowned crane of Japan for good fortune, love and long life."),
            KoiCard(
                imageUrl:
                    "https://www.kodamakoifarm.com/wp-content/uploads/2018/03/Utsurimono.jpg",
                name: "Utsurimono",
                description:
                    "The base of their body is sumi (black), and utsuri means “reflection”. There are three beautiful varieties of Utsurimono including Hi (red), Shiro (white) or Ki (yellow)."),
            KoiCard(
                imageUrl:
                    "https://www.magic-koi.com/fileadmin/_processed_/2/7/csm_10-002_Kuyjaku_62_cm-min_2cfdef56ca.jpg",
                name: "Hikarimoyomono",
                description:
                    "a metallic-scaled variety known for its shimmering appearance and vibrant patterns. This koi category combines metallic luster with distinct patterns, which can include spots or patches of various colors like red, black, or yellow."),
          ],
        ),
      ),
    );
  }
}
