import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

import 'models/power_pu_curve.dart';
import 'models/power_pump_curve.dart';
import 'models/setupApp.dart';

class PumpPowerCurveChart extends StatelessWidget {
  PumpPowerCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads = gi<PowerPumpCurveLogic>();

    return ValueListenableBuilder<List<PowerPumpCurve>>(
        valueListenable: pumpCurvesWithHeads.powerPumpCurves,
        builder: (context, pumpCurvesWithHeads, _) {
          List<ChartPumpCurve> chartPumpCurves = pumpCurvesWithHeads.map((pc) {
            final head = pc.head;
            final axis = pc.points
                .map((point) => Axis(x: point.bHp, y: point.flow))
                .toList();
            return ChartPumpCurve(head: head, axis: axis);
          }).toList();

          return PowerPumpCurveChart(
              chartPumpCurves: chartPumpCurves,
              xAxisTitle: 'Brake Power (HP)',
              yAxisTitle: 'Flow (m3/h)',
              lineColor: Theme.of(context).primaryColorLight);
        });
  }

  //generates the different pump curve lines
}

class PUPowerCurveChart extends StatelessWidget {
  PUPowerCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads = gi<PowerPumpCurveLogic>();

    return ValueListenableBuilder<List<PowerPUCurve>>(
        valueListenable: pumpCurvesWithHeads.powerPUCurves,
        builder: (context, pumpCurvesWithHeads, _) {
          List<ChartPumpCurve> chartPumpCurves = pumpCurvesWithHeads.map((pc) {
            final head = pc.head;
            final axis = pc.points
                .map((point) =>
                    Axis(x: point.requiredkW, y: point.pumpCurvePoint.flow))
                .toList();
            return ChartPumpCurve(head: head, axis: axis);
          }).toList();

          return PowerPumpCurveChart(
            chartPumpCurves: chartPumpCurves,
            xAxisTitle: 'Required Power (kW)',
            yAxisTitle: 'Flow (m3/h)',
            lineColor: Theme.of(context).primaryColor,
          );
        });
  }

//generates the different pump curve lines
}

class EfficiencyCurveChart extends StatelessWidget {
  EfficiencyCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads = gi<PowerPumpCurveLogic>();

    return ValueListenableBuilder<List<PowerPUCurve>>(
        valueListenable: pumpCurvesWithHeads.powerPUCurves,
        builder: (context, pumpCurvesWithHeads, _) {
          List<ChartPumpCurve> chartPumpCurves = pumpCurvesWithHeads.map((pc) {
            final head = pc.head;
            final axis = pc.points
                .map((point) =>
                    Axis(x: point.requiredkW, y: point.efficiency * 100))
                .toList();
            return ChartPumpCurve(head: head, axis: axis);
          }).toList();

          return PowerPumpCurveChart(
            chartPumpCurves: chartPumpCurves,
            xAxisTitle: 'Required Power (kW)',
            yAxisTitle: 'Efficiency %',
            lineColor: Colors.brown,
          );
        });
  }

//generates the different pump curve lines
}

class PowerPumpCurveChart extends StatelessWidget {
  const PowerPumpCurveChart({
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

  List<LineSeries<Axis, double>> series(
      List<ChartPumpCurve> chartPumpCurve, Color lineColor) {
    return chartPumpCurve
        .map((pumpCurve) => LineSeries<Axis, double>(
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
  List<Axis> axis;
  ChartPumpCurve({required this.head, required this.axis});
}

class Axis {
  double x;
  double y;
  Axis({required this.x, required this.y});
}
