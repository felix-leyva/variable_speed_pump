import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/models/pump_curve_point.dart';
import 'package:variable_speed_pump/utils/constants.dart';

import 'data_sources/pump_curves_sources.dart';

final GetIt gi = GetIt.I;

void setupApp() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PumpCurvePointAdapter());

  gi.registerSingletonAsync<PumpCurvesSources>(
    () async {
      Box<List> box = await Hive.openBox<List>(pumpCurveBoxName);
      return PumpCurvesDB(box);
    },
  );

  gi.registerSingletonWithDependencies<PowerPumpCurveLogic>(
    () => PowerPumpCurveLogic(),
    dependsOn: [
      PumpCurvesSources,
    ],
  );
}
