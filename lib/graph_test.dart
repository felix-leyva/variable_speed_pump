import 'package:equations/equations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:variable_speed_pump/utils/constants.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

import 'models/pump_curve.dart';

class GraphTest extends StatefulWidget {
  const GraphTest({Key? key}) : super(key: key);

  @override
  _GraphTestState createState() => _GraphTestState();
}

class _GraphTestState extends State<GraphTest> {
  List<FlSpot> generateSpots() {
    var frequencies = [60, 55, 50, 45, 40, 30];

    return frequencies
        .expand((freq) => curveWithFreq(freq)..add(FlSpot.nullSpot))
        .toList();
  }

  var secondSpots = [
    FlSpot(1, 1),
    FlSpot(2, 2),
    FlSpot(3, 6),
    FlSpot(4, 8),
    FlSpot(4.6, 9),
    FlSpot(5, 10),
  ];

  List<double> generateRanges(int steps) {
    var start = pumpCurve.first.flow;
    var end = pumpCurve.last.flow;
    var step = (end - start) / steps;

    return List<double>.generate(100, (index) => start + index * step);
  }

  LineChartBarData generateEfficiency() {
    var nodes = pumpCurve
        .map((e) => InterpolationNode(x: e.flow, y: e.pumpEndEff))
        .toList();
    var splineNodes = SplineInterpolation(nodes: nodes);

    List<double> ranges = generateRanges(100);

    var spots =
        ranges.map((e) => FlSpot(e, splineNodes.compute(e) * 100)).toList();

    return LineChartBarData(
      colors: [Colors.red],
      barWidth: 5,
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.2,
      dotData: FlDotData(
        show: false,
      ),
    );
  }

  List<LineChartBarData> generateChartData() {
    var frequencies = [60, 55, 50, 45, 40, 30];

    return frequencies
        .map(
          (freq) => LineChartBarData(
            colors: [Colors.blueAccent.withAlpha(((freq / 60) * 255).toInt())],
            barWidth: 5,
            spots: curveWithFreq(freq),
            isCurved: true,
            curveSmoothness: 0.2,
            dotData: FlDotData(
              show: true,
            ),
          ),
        )
        .toList();
  }

  List<FlSpot> curveWithFreq(int freq) {
    return pumpCurve
        .map((pcp) => pcp.withLowerSpeed(freq / 60))
        .map((newPCP) => FlSpot(newPCP.flow, newPCP.head))
        .toList();
  }

  List<LineChartBarData> generatePowerData() {
    final List<double> head = [25, 30.0, 35, 40, 45, 50];

    return head
        .map(
          (freq) => LineChartBarData(
            colors: [Colors.blueAccent],
            barWidth: 5,
            spots: curveWithHead(freq),
            // isCurved: true,
            // curveSmoothness: 0.2,
            dotData: FlDotData(
              show: false,
            ),
          ),
        )
        .toList();
  }

  List<FlSpot> curveWithHead(double head) {
    final powerPumpCurve = PumpCurve(rpm: 3600.0, points: pumpCurve)
        .powerPumpCurveWithHead(head: head);

    return powerPumpCurve.points.reversed
        .map((newPCP) => FlSpot(newPCP.bHp, newPCP.flow))
        .toList();
  }

  List<LineTooltipItem> toolTipsFormat(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      final textStyle = TextStyle(
        color: touchedSpot.bar.colors[0],
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );
      return LineTooltipItem(
          'Q:${touchedSpot.y.roundD(2).toString()} / P:${touchedSpot.x.roundD(2).toString()}',
          textStyle);
    }).toList();
  }

  var first = true;

  @override
  Widget build(BuildContext context) {
    LineChartData lineChartData = LineChartData(lineBarsData: [
      // LineChartBarData(
      //     colors: [Colors.blueAccent],
      //     barWidth: 5,
      //     spots: first ? generateSpots() : secondSpots,
      //     isCurved: true,
      //     curveSmoothness: 0.2,
      //     dotData: FlDotData(
      //       show: true,
      //     ),
      //     belowBarData: BarAreaData(
      //       show: true,
      //     )),
      generateEfficiency(),
    ]);

    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: (16 / 9),
            child: LineChart(
              LineChartData(
                // lineBarsData: [...generatePowerData(), ...generateChartData(), generateEfficiency()],
                lineBarsData: [
                  ...generatePowerData(),
                ],

                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.white,
                    tooltipRoundedRadius: 10,
                    getTooltipItems: toolTipsFormat,
                    fitInsideVertically: true,
                  ),
                ),
              ), //lineChartData,
              swapAnimationDuration: Duration(milliseconds: 200),
              swapAnimationCurve: Curves.linear,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  first = !first;
                });
              },
              child: Text(first ? 'First' : 'Second'))
        ],
      ),
    );
  }
}
