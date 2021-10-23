import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:variable_speed_pump/models/curve_charts/chart_pump_curve.dart';
import 'package:variable_speed_pump/models/curve_charts/pump_curve_chart_axis.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class VariableSpeedCurveChart extends StatelessWidget {
  const VariableSpeedCurveChart({
    Key? key,
    required this.yAxisTitle,
    required this.xAxisTitle,
    required this.chartCurves,
    required this.lineColors,
  }) : super(key: key);

  final List<ChartPumpCurve> chartCurves;
  final String xAxisTitle;
  final String yAxisTitle;
  final List<Color> lineColors;

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
      series: series(chartCurves, lineColors),
    );
  }

  List<LineSeries<PumpCurveChartAxis, double>> series(
      List<ChartPumpCurve> chartPumpCurves, List<Color> lineColors) {
    return chartPumpCurves
        .mapIndexed(
          (index, pumpCurve) => LineSeries<PumpCurveChartAxis, double>(
            color: lineColors[index],
            name: "${pumpCurve.nameVal.roundD(0)} rpm",
            dataSource: pumpCurve.axis,
            xValueMapper: (pcp, _) => pcp.x.roundD(1),
            yValueMapper: (pcp, _) => pcp.y.roundD(1),
            markerSettings: MarkerSettings(isVisible: true),
            legendItemText: "${pumpCurve.nameVal.roundD(0)} rpm",
            isVisibleInLegend: true,
          ),
        )
        .toList();
  }
}
