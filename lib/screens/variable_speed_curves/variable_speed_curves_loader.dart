import 'package:flutter/material.dart';
import 'package:variable_speed_pump/navigation/drawer_menu.dart';
import 'package:variable_speed_pump/screens/dialogs/open_pump_unit_list_dialog.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_body.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_logic.dart';

import '../../setupApp.dart';

class VariableSpeedCurvesLoader extends StatelessWidget {
  const VariableSpeedCurvesLoader({Key? key}) : super(key: key);
  static const id = '/VariableSpeedCurvesLoader';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gi.isReady<VariableSpeedCurvesLogic>(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Scaffold(
            drawer: drawerMenu(context, id),
            appBar: AppBar(
              title: Text('Variable speed curves'),
              actions: [
                IconButton(
                  onPressed: () => openPumpDialog(
                    context: context,
                    openFunction: (currentPUKey) => gi
                        .get<VariableSpeedCurvesLogic>()
                        .setPumpCurves(currentPUKey),
                    pumpUnitNames:
                        gi.get<VariableSpeedCurvesLogic>().pumpUnitNames.value,
                  ),
                  icon: Icon(Icons.folder_open),
                ),
              ],
            ),
            body: VariableSpeedCurvesBody(),
          );
        }
      },
    );
  }
}
