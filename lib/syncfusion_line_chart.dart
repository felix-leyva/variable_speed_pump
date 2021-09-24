import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

import 'models/pump_curve_point.dart';
import 'models/setupApp.dart';

class PumpPowerCurveChart extends StatelessWidget {
  PumpPowerCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads = gi<PumpCurveLogic>();
    const axisLabelSize = 10.0;

    return ValueListenableBuilder<List<List<PumpCurvePoint>>>(
        valueListenable: pumpCurvesWithHeads.pumpCurvesWithHeads,
        builder: (context, pumpCurvesWithHeads, _) {
          return SfCartesianChart(
            primaryXAxis: NumericAxis(
              title: AxisTitle(
                text: 'Brake Power (HP)',
                textStyle: TextStyle(fontSize: axisLabelSize),
              ),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Flow (m3/h)',
                textStyle: TextStyle(fontSize: axisLabelSize),
              ),
            ),
            legend: Legend(
              borderWidth: 1,
              borderColor: Colors.black87,
              title: LegendTitle(text: 'Pump Head'),
              isVisible: false,
              position: LegendPosition.bottom,
            ),
            // crosshairBehavior: _crosshairBehavior,
            tooltipBehavior: TooltipBehavior(
              enable: true,
              shared: true,
            ),
            series: series(pumpCurvesWithHeads),
          );
        });
  }

  //generates the different pump curve lines
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
