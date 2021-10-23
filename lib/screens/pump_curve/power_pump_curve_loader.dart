import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:variable_speed_pump/navigation/navigation.dart';
import 'package:variable_speed_pump/screens/dialogs/open_pump_unit_list_dialog.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_loader.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_body.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';

import '../../navigation/drawer_menu.dart';
import '../../setupApp.dart';

class PowerPumpCurveLoader extends StatelessWidget {
  const PowerPumpCurveLoader({
    Key? key,
  }) : super(key: key);
  static const String id = '/PowerPumpCurveLoader';
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gi.isReady<PowerPumpCurveLogic>(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          gi.get<PowerPumpCurveLogic>().openPumpCurves(null);
          return Scaffold(
            drawer: drawerMenu(context, id),
            appBar: AppBar(
              title: Text('Pump unit curve with variable power'),
              actions: [
                IconButton(
                    onPressed: () => loadPage(context, PumpCurveEditLoader.id),
                    icon: Icon(Icons.edit)),
                IconButton(
                  onPressed: () => openPumpDialog(
                    pumpUnitNames:
                        gi<PowerPumpCurveLogic>().pumpUnitNames.value,
                    context: context,
                    openFunction: (key) =>
                        gi<PowerPumpCurveLogic>().openPumpCurves(key),
                  ),
                  icon: Icon(Icons.folder_open),
                ),
              ],
            ),
            body: PowerPumpCurveBody(),
          );
        }
      },
    );
  }
}
