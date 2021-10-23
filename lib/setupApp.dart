import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variable_speed_pump/data_sources/preferences_sources.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/screens/input_table/pump_curve_input_logic.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/screens/variable_speed_curves/variable_speed_curves_logic.dart';

import 'models/pump_curve/pump_curve.dart';
import 'models/pump_curve_points/pump_curve_point.dart';

final GetIt gi = GetIt.I;

Future setupApp() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(PumpCurvePointAdapter())
    ..registerAdapter(MotorAdapter())
    ..registerAdapter(PumpCurveAdapter())
    ..registerAdapter(PumpUnitAdapter());

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

  gi.registerSingletonAsync<PreferencesSource>(() async {
    Box<String> preferencesBox =
        await Hive.openBox<String>(PreferencesDb.boxName);
    return PreferencesDb(preferencesBox);
  });

//  await registerPumpCurveInputLogic();

  await registerPowerPumpCurveLogic();

//  await registerVariableSpeedCurvesLogic();

  return Future;
}

Future<void> registerVariableSpeedCurvesLogic() async {
  if (!gi.isRegistered<VariableSpeedCurvesLogic>()) {
    gi.registerLazySingletonAsync<VariableSpeedCurvesLogic>(() async {
      await gi.isReady<PumpUnitSource>();
      await gi.isReady<PreferencesSource>();
      return VariableSpeedCurvesLogic();
    });
  }
}

Future<void> registerPowerPumpCurveLogic() async {
  if (!gi.isRegistered<PowerPumpCurveLogic>()) {
    gi.registerLazySingletonAsync<PowerPumpCurveLogic>(() async {
      await gi.isReady<PumpUnitSource>();
      await gi.isReady<PreferencesSource>();
      return PowerPumpCurveLogic();
    });
  }
}

Future<void> registerPumpCurveInputLogic() async {
  if (!gi.isRegistered<PumpCurveInputLogic>()) {
    gi.registerLazySingletonAsync<PumpCurveInputLogic>(
      () async {
        await gi.isReady<PumpUnitSource>();
        await gi.isReady<PreferencesSource>();
        return PumpCurveInputLogic();
      },
    );
  }
}
