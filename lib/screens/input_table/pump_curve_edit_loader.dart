import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/screens/dialogs/input_name_to_save_PU.dart';
import 'package:variable_speed_pump/screens/dialogs/open_pump_unit_list_dialog.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_table.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_charts.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_name_input.dart';

import '../../setupApp.dart';
import '../drawer_menu.dart';

class PumpCurveEditLoader extends StatelessWidget {
  const PumpCurveEditLoader({Key? key}) : super(key: key);
  static const id = '/PumpCurveEditLoader';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: gi.isReady<PumpCurveInputLogic>(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        } else {
          gi.get<PumpCurveInputLogic>().openPumpUnit(null);
          return Scaffold(
            drawer: drawerMenu(context, id),
            appBar: AppBar(
              title: Text('Edit Pump Curve'),
              actions: [
                IconButton(
                  onPressed: () => savePUDialog(
                    context: context,
                    saveFunction: (name) => GetIt.I
                        .get<PumpCurveInputLogic>()
                        .createNewPumpUnitWithName(name),
                  ),
                  icon: Icon(Icons.add),
                ),
                IconButton(
                  onPressed: () => openPumpDialog(
                    context: context,
                    openFunction: (key) =>
                        GetIt.I.get<PumpCurveInputLogic>().openPumpUnit(key),
                  ),
                  icon: Icon(Icons.folder_open),
                ),
              ],
            ),
            body: PumpCurveEditBody(),
          );
        }
      },
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
        Flexible(flex: 0, child: PumpCurveNameInput()),
        Flexible(flex: 5, child: PumpCurveInputList()),
      ],
    );
  }
}
