import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:variable_speed_pump/models/curve_charts/chart_pump_curve.dart';
import 'package:variable_speed_pump/models/curve_charts/pump_curve_chart_axis.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curve_chart.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_logic.dart';
import 'package:variable_speed_pump/setupApp.dart';

class VariableSpeedCurvesBody extends StatelessWidget {
  const VariableSpeedCurvesBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          VariableSpeedPUChart(),
        ],
      ),
    );
  }
}

class VariableSpeedPUChart extends StatelessWidget {
  const VariableSpeedPUChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = gi.get<VariableSpeedCurvesLogic>();
    return ValueListenableBuilder<List<PumpCurve>>(
      valueListenable: logic.speedPumpCurves,
      builder: (context, curves, _) {
        final chartCurves = curves
            .map(
              (curve) => ChartPumpCurve(
                nameVal: curve.rpm,
                axis: curve.points
                    .map((p) => PumpCurveChartAxis(x: p.flow, y: p.head))
                    .toList(),
              ),
            )
            .toList();

        final List<Color> lineColors = curves
            .mapIndexed((index, element) => Colors.blueAccent
                .withOpacity(1 - ((index / curves.length) * (.5))))
            .sorted((a, b) => b.opacity.compareTo(a.opacity));

        return VariableSpeedCurveChart(
          yAxisTitle: 'Head (m)',
          xAxisTitle: 'Flow (m3/h)',
          chartCurves: chartCurves,
          lineColors: lineColors,
        );
      },
    );
  }
}
