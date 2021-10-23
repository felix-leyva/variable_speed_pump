import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_loader.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_loader.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_loader.dart';

import 'setupApp.dart';

void main() async {
  await setupApp();
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.green,
              primaryColorDark: Colors.red,
              accentColor: Colors.amber)),
      routes: {
        PowerPumpCurveLoader.id: (context) => PowerPumpCurveLoader(),
        PumpCurveEditLoader.id: (context) => PumpCurveEditLoader(),
        VariableSpeedCurvesLoader.id: (context) => VariableSpeedCurvesLoader(),
      },
      initialRoute: PowerPumpCurveLoader.id,
    );
  }
}
