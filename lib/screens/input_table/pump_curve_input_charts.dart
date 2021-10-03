import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_table.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/utils/functions.dart';

class NormalPumpCurve extends StatelessWidget {
  const NormalPumpCurve({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? Function(PumpCurvePointInput, int) xValueMapper =
        (pcp, _) => pcp.flow.roundD(2);
    double? Function(PumpCurvePointInput, int) yValueMapper =
        (pcp, _) => pcp.head.roundD(2);
    Color lineColor = Colors.lightBlue;

    return PumpCurveChart(
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
      lineColor: lineColor,
      chartName: 'Flow/Head Curve',
      yAxisName: 'Head (m)',
    );
  }
}

class EfficiencyPumpCurve extends StatelessWidget {
  const EfficiencyPumpCurve({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? Function(PumpCurvePointInput, int) xValueMapper =
        (pcp, _) => pcp.flow.roundD(2);
    double? Function(PumpCurvePointInput, int) yValueMapper =
        (pcp, _) => pcp.efficiencyOrPower.roundD(2);
    Color lineColor = Colors.brown;

    return PumpCurveChart(
      xValueMapper: xValueMapper,
      yValueMapper: yValueMapper,
      lineColor: lineColor,
      chartName: 'Pump End Efficiency Curve',
      yAxisName: 'Efficiency (%)',
    );
  }
}

class PumpCurveChart extends StatelessWidget {
  const PumpCurveChart({
    Key? key,
    required this.xValueMapper,
    required this.yValueMapper,
    required this.lineColor,
    required this.chartName,
    required this.yAxisName,
  }) : super(key: key);

  final double? Function(PumpCurvePointInput, int) xValueMapper;
  final double? Function(PumpCurvePointInput, int) yValueMapper;
  final Color lineColor;
  final String chartName;
  final String yAxisName;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ValueListenableBuilder<List<PumpCurvePointInput>>(
        valueListenable:
            GetIt.I.get<PumpCurveInputLogic>().pumpCurvePointInputs,
        builder: (context, inputs, _) {
          return SfCartesianChart(
            title:
                ChartTitle(text: chartName, textStyle: TextStyle(fontSize: 10)),
            primaryXAxis: NumericAxis(
              title: AxisTitle(
                text: 'Flow (m3/h)',
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: yAxisName,
                textStyle: TextStyle(fontSize: 10),
              ),
            ),
            crosshairBehavior: CrosshairBehavior(
              enable: true,
              activationMode: ActivationMode.longPress,
            ),
            series: [
              LineSeries<PumpCurvePointInput, double>(
                markerSettings: MarkerSettings(isVisible: true),
                color: lineColor,
                name: "Data Input",
                dataSource: inputs,
                xValueMapper: xValueMapper,
                yValueMapper: yValueMapper,
              ),
            ],
          );
        },
      ),
    );
  }
}
