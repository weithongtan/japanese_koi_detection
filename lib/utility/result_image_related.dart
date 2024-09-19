import 'package:flutter/material.dart';

class KoiImageContainer extends StatelessWidget {
  final String koiImage;

  const KoiImageContainer({Key? key, required this.koiImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.4,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: AssetImage(koiImage),
          fit: BoxFit.fitHeight,
        ),
      ),
    );
  }
}
