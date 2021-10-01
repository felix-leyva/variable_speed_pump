import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/utils/constants.dart';

import 'data_sources/pump_curves_sources.dart';
import 'models/pump_curve/pump_curve.dart';
import 'models/pump_curve_points/pump_curve_point.dart';

final GetIt gi = GetIt.I;

void setupApp() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(PumpCurvePointAdapter())
    ..registerAdapter(MotorAdapter())
    ..registerAdapter(PumpCurveAdapter())
    ..registerAdapter(PumpUnitAdapter());

  gi.registerSingletonAsync<PumpCurvesSources>(
    () async {
      Box<List> box = await Hive.openBox<List>(pumpCurveBoxName);
      return PumpCurvesDB(box);
    },
  );

  gi.registerSingletonAsync<PumpUnitSource>(
    () async {
      // await Hive.deleteBoxFromDisk(PumpUnitDb.pumpUnitBoxName);
      // await Hive.deleteBoxFromDisk(PumpUnitDb.pumpUnitNamesBoxName);

      Box<PumpUnit> pumpUnitBox =
          await Hive.openBox<PumpUnit>(PumpUnitDb.pumpUnitBoxName);
      Box<String> pumpUnitNamesBox =
          await Hive.openBox<String>(PumpUnitDb.pumpUnitNamesBoxName);
      return PumpUnitDb(pumpUnitBox, pumpUnitNamesBox);
    },
  );

  gi.registerSingletonWithDependencies<PumpCurveInputLogic>(
      () => PumpCurveInputLogic(),
      dependsOn: [
        PumpUnitSource,
      ]);

  gi.registerSingletonWithDependencies<PowerPumpCurveLogic>(
    () => PowerPumpCurveLogic(),
    dependsOn: [
      PumpCurvesSources,
    ],
  );
}
