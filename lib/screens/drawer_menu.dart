import 'package:flutter/material.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_loader.dart';

import 'input_table/pump_curve_edit_loader.dart';

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
          onTap: () async {
            await Navigator.pushReplacementNamed(
                context, PowerPumpCurveLoader.id);
          },
        ),
        ListTile(
          enabled: idLoader != PumpCurveEditLoader.id ? true : false,
          title: Row(
            children: [
              Icon(Icons.edit),
              Text('Edit Pump Curves'),
            ],
          ),
          onTap: () async {
            await Navigator.pushReplacementNamed(
                context, PumpCurveEditLoader.id);
          },
        ),
      ],
    ),
  );
}
