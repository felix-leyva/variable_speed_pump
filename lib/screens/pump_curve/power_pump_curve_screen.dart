import 'package:flutter/material.dart';
import 'package:variable_speed_pump/models/curve_charts/chart_pump_curve.dart';
import 'package:variable_speed_pump/models/curve_charts/pump_curve_chart_axis.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_chart.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';

import '../../models/power_pump_unit_curve.dart';
import '../../setupApp.dart';

class PumpPowerCurveChart extends StatelessWidget {
  PumpPowerCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurveLogic = gi<PowerPumpCurveLogic>();

    return ValueListenableBuilder<List<PowerPumpUnitCurve>>(
        valueListenable: pumpCurveLogic.powerPUCurves,
        builder: (context, pumpCurvesWithHeads, _) {
          List<ChartPumpCurve> chartPumpCurves = pumpCurvesWithHeads.map((pc) {
            final head = pc.head;
            final axis = pc.powerPumpUnitPoints
                .map((point) => PumpCurveChartAxis(
                    x: point.pumpCurvePoint.head, y: point.pumpCurvePoint.flow))
                .toList();
            return ChartPumpCurve(nameVal: head, axis: axis);
          }).toList();

          return PumpCurveChart(
              chartPumpCurves: chartPumpCurves,
              xAxisTitle: 'Brake Power (HP)',
              yAxisTitle: 'Flow (m3/h)',
              lineColor: Theme.of(context).primaryColorLight);
        });
  }
}

class PUPowerCurveChart extends StatelessWidget {
  PUPowerCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads = gi<PowerPumpCurveLogic>();

    return ValueListenableBuilder<List<PowerPumpUnitCurve>>(
        valueListenable: pumpCurvesWithHeads.powerPUCurves,
        builder: (context, pumpCurvesWithHeads, _) {
          List<ChartPumpCurve> chartPumpCurves = pumpCurvesWithHeads.map((pc) {
            final head = pc.head;
            final axis = pc.powerPumpUnitPoints
                .map((point) => PumpCurveChartAxis(
                    x: point.requiredkW, y: point.pumpCurvePoint.flow))
                .toList();
            return ChartPumpCurve(nameVal: head, axis: axis);
          }).toList();

          return PumpCurveChart(
            chartPumpCurves: chartPumpCurves,
            xAxisTitle: 'Required Power (kW)',
            yAxisTitle: 'Flow (m3/h)',
            lineColor: Theme.of(context).primaryColor,
          );
        });
  }
}

class EfficiencyCurveChart extends StatelessWidget {
  EfficiencyCurveChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pumpCurvesWithHeads = gi<PowerPumpCurveLogic>();

    return ValueListenableBuilder<List<PowerPumpUnitCurve>>(
        valueListenable: pumpCurvesWithHeads.powerPUCurves,
        builder: (context, pumpCurvesWithHeads, _) {
          List<ChartPumpCurve> chartPumpCurves = pumpCurvesWithHeads.map((pc) {
            final head = pc.head;
            final axis = pc.powerPumpUnitPoints
                .map((point) => PumpCurveChartAxis(
                    x: point.requiredkW, y: point.efficiency * 100))
                .toList();
            return ChartPumpCurve(nameVal: head, axis: axis);
          }).toList();

          return PumpCurveChart(
            chartPumpCurves: chartPumpCurves,
            xAxisTitle: 'Required Power (kW)',
            yAxisTitle: 'Efficiency %',
            lineColor: Colors.brown,
          );
        });
  }
}
