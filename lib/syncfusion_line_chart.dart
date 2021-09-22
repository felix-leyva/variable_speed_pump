import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_provider.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

import 'models/pump_curve_point.dart';

class LineChart extends StatefulWidget {
  const LineChart({Key? key}) : super(key: key);

  @override
  _LineChartState createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
      enable: true,
      shared: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads =
        context.watch<PumpCurveProvider>().pumpCurvesWithHeads;

    return SfCartesianChart(
      primaryXAxis: NumericAxis(),
      legend: Legend(isVisible: true),
      // crosshairBehavior: _crosshairBehavior,
      tooltipBehavior: _tooltipBehavior,
      series: series(pumpCurvesWithHeads),
    );
  }

  List<LineSeries<PumpCurvePoint, double>> series(
      List<List<PumpCurvePoint>> pumpCurvesWithHeads) {
    return pumpCurvesWithHeads
        .map((pumpCurve) => LineSeries<PumpCurvePoint, double>(
            name: "${pumpCurve.first.head} m",
            dataSource: pumpCurve,
            xValueMapper: (pcp, _) => pcp.bHp.roundD(1),
            yValueMapper: (pcp, _) => pcp.flow))
        .toList();
  }
}
