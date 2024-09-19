import 'package:flutter/material.dart';
import 'package:koi_detection_flutter_app/utility/constant.dart';

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxLines;
  final String readMoreText;
  final String readLessText;

  const ReadMoreText({
    super.key,
    required this.text,
    this.maxLines = 3,
    this.readMoreText = 'Read more',
    this.readLessText = 'Read less',
  });

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

class ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Text(
              widget.text,
              style: normalText,
              maxLines: isExpanded ? null : widget.maxLines,
              overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            ),
          ],
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(6),
          child: GestureDetector(
            child: Text(
              isExpanded ? widget.readLessText : widget.readMoreText,
              style: const TextStyle(color: Colors.blue),
            ),
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
          ),
        ),
      ],
    );
  }
}
