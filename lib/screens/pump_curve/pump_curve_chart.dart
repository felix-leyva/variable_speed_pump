import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class PumpCurveChart extends StatelessWidget {
  const PumpCurveChart({
    Key? key,
    required this.chartPumpCurves,
    required this.xAxisTitle,
    required this.yAxisTitle,
    required this.lineColor,
  }) : super(key: key);

  final List<ChartPumpCurve> chartPumpCurves;
  final String xAxisTitle;
  final String yAxisTitle;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    const axisLabelSize = 10.0;

    return SfCartesianChart(
      primaryXAxis: NumericAxis(
        title: AxisTitle(
          text: xAxisTitle,
          textStyle: TextStyle(fontSize: axisLabelSize),
        ),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(
          text: yAxisTitle,
          textStyle: TextStyle(fontSize: axisLabelSize),
        ),
      ),
      crosshairBehavior: CrosshairBehavior(
        enable: true,
        activationMode: ActivationMode.longPress,
      ),
      series: series(chartPumpCurves, lineColor),
    );
  }

  List<LineSeries<PumpCurveChartAxis, double>> series(
      List<ChartPumpCurve> chartPumpCurve, Color lineColor) {
    return chartPumpCurve
        .map((pumpCurve) => LineSeries<PumpCurveChartAxis, double>(
            color: lineColor,
            name: "${pumpCurve.head} m",
            dataSource: pumpCurve.axis,
            xValueMapper: (pcp, _) => pcp.x.roundD(1),
            yValueMapper: (pcp, _) => pcp.y.roundD(1)))
        .toList();
  }
}

class ChartPumpCurve {
  double head;
  List<PumpCurveChartAxis> axis;
  ChartPumpCurve({required this.head, required this.axis});
}

class PumpCurveChartAxis {
  double x;
  double y;
  PumpCurveChartAxis({required this.x, required this.y});
}
