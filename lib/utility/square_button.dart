import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String text;
  final Function() func;
  final Icon icon;

  const SquareButton({Key? key, required this.text, required this.func, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: InkWell(
        onTap: () {
          // Handle button tap
          func();
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 52, 52, 52), // Grey in the top left
                Color.fromARGB(255, 79, 79, 79), // Lighter grey in the bottom right
              ],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            children: [
              icon,
              Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    
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
