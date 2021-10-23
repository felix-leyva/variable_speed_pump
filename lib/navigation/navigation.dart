import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_edit_loader.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/screens/pump_curve/power_pump_curve_loader.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_loader.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_logic.dart';

import '../setupApp.dart';

void loadPage(BuildContext context, String id) async {
  switch (id) {
    case PumpCurveEditLoader.id:
      await registerPumpCurveInputLogic();
      await GetIt.I.resetLazySingleton<PumpCurveInputLogic>();
      await Navigator.pushReplacementNamed(context, id);
      break;
    case PowerPumpCurveLoader.id:
      await registerPowerPumpCurveLogic();
      await GetIt.I.resetLazySingleton<PowerPumpCurveLogic>();
      await Navigator.pushReplacementNamed(context, id);
      break;
    case VariableSpeedCurvesLoader.id:
      await registerVariableSpeedCurvesLogic();
      await GetIt.I.resetLazySingleton<VariableSpeedCurvesLogic>();
      await Navigator.pushReplacementNamed(context, id);
      break;
  }
}
