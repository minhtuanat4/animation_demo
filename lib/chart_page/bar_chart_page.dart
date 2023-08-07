import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChartPage extends StatefulWidget {
  const ColumnChartPage({super.key});

  @override
  State<ColumnChartPage> createState() => _ColumnChartPageState();
}

class _ColumnChartPageState extends State<ColumnChartPage> {
  late SelectionBehavior _selectionBehavior;
  final chartData = const [
    ChartData('USA', 200),
    ChartData('China', 11),
    ChartData('UK', 9),
    ChartData('Japan', 14),
    ChartData('Japan1', 14),
    ChartData('Japan2', 14),
    ChartData('France', 10),
  ];
  @override
  void initState() {
    _selectionBehavior = SelectionBehavior(
      enable: true,
      selectedColor: Colors.red,
      unselectedColor: Colors.grey,
      selectedOpacity: 0.5,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        AspectRatio(
            aspectRatio: 1.5,
            child: SfCartesianChart(
                title: ChartTitle(
                    text: 'Half yearly sales analysis',
                    backgroundColor: Colors.lightGreen,
                    borderColor: Colors.blue,
                    borderWidth: 2,
                    // Aligns the chart title to left
                    alignment: ChartAlignment.center,
                    textStyle: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Roboto',
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    )),
                primaryYAxis: NumericAxis(
                    // Additional range padding is applied to y axis
                    rangePadding: ChartRangePadding.auto),
                primaryXAxis: CategoryAxis(
                    labelAlignment: LabelAlignment.center,
                    autoScrollingMode: AutoScrollingMode.start),
                series: <ChartSeries<ChartData, String>>[
                  ColumnSeries<ChartData, String>(
                      color: Colors.grey,
                      opacity: 0.5,
                      dataSource: chartData,
                      selectionBehavior: _selectionBehavior,
                      spacing: 0.4,
                      animationDuration: 2000,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(2),
                      ),
                      dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          )),
                      onPointTap: (pointInteractionDetails) {},
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ])),
      ],
    ));
  }
}

class ChartData {
  const ChartData(this.x, this.y);
  final String x;
  final double? y;
}
