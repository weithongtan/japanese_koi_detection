import 'package:flutter/material.dart';

class PriceRange extends StatefulWidget {
  final RangeValues initialRange;

  const PriceRange({super.key, required this.initialRange});

  @override
  PriceRangeState createState() => PriceRangeState();
}

class PriceRangeState extends State<PriceRange> {
  late RangeValues _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.initialRange;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
              showValueIndicator: ShowValueIndicator.always,
              disabledThumbColor: const Color.fromARGB(255, 129, 198, 255)),
          child: RangeSlider(
              values: _selectedRange,
              max: 2000,
              divisions: 5,
              labels: RangeLabels(
                _selectedRange.start.round().toString(),
                _selectedRange.end.round().toString(),
              ),
              onChanged: null),
        ),
        _selectedRange.end != 0 ? Text(
          _selectedRange.end >= 2000
              ? "Range: more than 2000"
              : 'Range: ${_selectedRange.start.round()} - ${_selectedRange.end.round()}',
          style: const TextStyle(fontSize: 20),
        ): const Text("Range: 0",style: TextStyle(fontSize: 20),),
      ],
    );
  }
}
