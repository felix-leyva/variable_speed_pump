import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_loader.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_body.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';

import '../../setupApp.dart';

class PowerPumpCurveLoader extends StatelessWidget {
  const PowerPumpCurveLoader({
    Key? key,
  }) : super(key: key);
  static const String id = 'PowerPumpCurveLoader';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pump Unit Curve with Variable Power'),
        actions: [
          IconButton(
              onPressed: () async => await Navigator.pushNamed(
                      context, PumpCurveEditLoader.id)
                  .then((value) => gi<PowerPumpCurveLogic>().setupPumpCurves()),
              icon: Icon(Icons.edit))
        ],
      ),
      body: FutureBuilder(
          future:
              Future.delayed(Duration(milliseconds: 1000), () => gi.allReady()),
          builder: (context, snapshot) {
            if (gi.isRegistered<PowerPumpCurveLogic>() && snapshot.hasData) {
              return PowerPumpCurveBody();
            } else
              return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
