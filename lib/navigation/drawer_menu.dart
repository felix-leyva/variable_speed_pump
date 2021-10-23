import 'package:flutter/material.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_loader.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_loader.dart';

import '../screens/input_table/pump_curve_edit_loader.dart';
import 'navigation.dart';

Widget drawerMenu(BuildContext context, String idLoader) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        ListTile(
          enabled: idLoader != PowerPumpCurveLoader.id ? true : false,
          title: Row(
            children: [
              Icon(Icons.multiline_chart),
              Text('View Power Pump Curves'),
            ],
          ),
          onTap: () => loadPage(context, PowerPumpCurveLoader.id),
        ),
        ListTile(
          enabled: idLoader != PumpCurveEditLoader.id ? true : false,
          title: Row(
            children: [
              Icon(Icons.edit),
              Text('Edit Pump Curves'),
            ],
          ),
          onTap: () => loadPage(context, PumpCurveEditLoader.id),
        ),
        ListTile(
          enabled: idLoader != VariableSpeedCurvesLoader.id ? true : false,
          title: Row(
            children: [
              Icon(Icons.multiline_chart),
              Text('Variable Speed Curves'),
            ],
          ),
          onTap: () => loadPage(context, VariableSpeedCurvesLoader.id),
        ),
      ],
    ),
  );
}
