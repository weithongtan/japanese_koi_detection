
import 'package:flutter/material.dart';
import 'package:koi_detection_flutter_app/utility/constant.dart';

class GFunction {
  // Static method to capitalize the first letter of a string
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) {
      return text;
    }
    return text.substring(0, 1).toUpperCase() + text.substring(1);
  }

  static Widget IconAndTitle(String t, Icon i){
    return Row(children: [i, const Text("  "), Text(t, style: titleNormalText,)],);
  }
  // Other static methods can be added here as needed
  

}
