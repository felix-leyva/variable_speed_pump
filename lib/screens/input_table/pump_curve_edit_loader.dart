import 'package:flutter/material.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_table.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_charts.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_name_input.dart';

import '../../setupApp.dart';

class PumpCurveEditLoader extends StatelessWidget {
  const PumpCurveEditLoader({Key? key}) : super(key: key);
  static const id = 'PumpCurveEditLoader';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Pump Curve'),
      ),
      body: FutureBuilder(
          future: Future.delayed(Duration(seconds: 1), () => gi.allReady()),
          builder: (context, snapshot) {
            if (gi.isRegistered<PumpCurveInputLogic>() && snapshot.hasData) {
              return PumpCurveEditBody();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class PumpCurveEditBody extends StatelessWidget {
  const PumpCurveEditBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(flex: 3, child: NormalPumpCurve()),
        Flexible(flex: 2, child: EfficiencyPumpCurve()),
        Flexible(flex: 1, child: PumpCurveNameInput()),
        Flexible(flex: 5, child: PumpCurveInputList()),
      ],
    );
  }
}
