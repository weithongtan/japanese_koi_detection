import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Statistic extends StatefulWidget {
  final List<dynamic> koiList;

  const Statistic({Key? key, required this.koiList}) : super(key: key);

  @override
  _StatisticState createState() => _StatisticState();
}

class _StatisticState extends State<Statistic> {
  late List<_KoiType> KoiTypeData;
  late List<_KoiPrice> KoiPriceData;
  late TooltipBehavior _tooltip;

  late Map<String, int> koiType;

  @override
  void initState() {
    KoiTypeData = [];
    KoiPriceData = [];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Iterate over the koiList and populate koiTypes list
    for (var item in widget.koiList) {
      // Cast the item to Map<String, dynamic>
      Map<String, dynamic> koiData = item as Map<String, dynamic>;

      String type = koiData['koi_type'];
      String price = koiData['koi_price'];

      // Check if the koiType is already in the koiTypes list
      var existingType = KoiTypeData.firstWhere(
          (koiType) => koiType.koiType == type,
          orElse: () => _KoiType(type, 0));

      var existingPrice = KoiPriceData.firstWhere(
          (koiPrice) => koiPrice.price == price,
          orElse: () => _KoiPrice(price, 0));

      // If the type exists, increment the quantity
      if (existingType.quantity > 0) {
        existingType.quantity++;
      } else {
        // Otherwise, add a new KoiType with quantity 1
        KoiTypeData.add(_KoiType(type, 1));
      }

      if (existingPrice.quantity > 0) {
        existingPrice.quantity++;
      } else {
        // Otherwise, add a new KoiType with quantity 1
        KoiPriceData.add(_KoiPrice(price, 1));
      }
    }
    for (var koiPrice in KoiPriceData) {
      if (koiPrice.price == '2000') {
        koiPrice.price = '>2000';
      }
      print('KoiType: ${koiPrice.price}, Quantity: ${koiPrice.quantity}');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 156, 147, 141),
        title: const Text('Dashboard'),
      ),
      body: Container(
        color: const Color.fromARGB(255, 156, 147, 141),
        child: Column(
          children: [
            SfCircularChart(
              margin: const EdgeInsets.symmetric(horizontal: 50),
              annotations: const <CircularChartAnnotation>[
                CircularChartAnnotation(
                    angle: 50, radius: '0%', widget: Text('Koi Type')),
              ],
              tooltipBehavior: _tooltip,
              series: <CircularSeries<_KoiType, String>>[
                DoughnutSeries<_KoiType, String>(
                  dataSource: KoiTypeData,
                  xValueMapper: (_KoiType data, _) => data.koiType,
                  yValueMapper: (_KoiType data, _) => data.quantity,
                  name: 'Sales',
                  // Enable data labels with both name and value
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.inside,
                    textStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    // Customize the label content to include both name and value
                    labelIntersectAction: LabelIntersectAction.shift,
                  ),
                  dataLabelMapper: (_KoiType data, _) =>
                      '${data.koiType}: ${data.quantity}', // Display name and value
                ),
              ],
            ),
            SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                primaryYAxis:
                    const NumericAxis(minimum: 0, maximum: 20, interval: 2),
                tooltipBehavior: _tooltip,
                series: <CartesianSeries<_KoiPrice, String>>[
                  ColumnSeries<_KoiPrice, String>(
                      dataSource: KoiPriceData,
                      xValueMapper: (_KoiPrice data, _) => data.price,
                      yValueMapper: (_KoiPrice data, _) => data.quantity,
                      name: 'Gold',
                      trendlines: const [],
                      color: const Color.fromARGB(255, 255, 8, 82))
                ]),
                const Center(child: Text("Koi Price"),)
          ],
        ),
      ),
    );
  }
}

class _KoiType {
  _KoiType(this.koiType, this.quantity);

  final String koiType;
  int quantity;
}

class _KoiPrice {
  _KoiPrice(this.price, this.quantity);

  String price;
  int quantity;
}
