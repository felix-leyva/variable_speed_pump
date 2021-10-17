import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variable_speed_pump/data_sources/preferences_sources.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/utils/constants.dart';

void main() {
  setupHive();
  late PowerPumpCurveLogic pcl;
  late PumpUnitSource pumpUnitDb;
  late PreferencesSource preferencesDb;

  final defaultPumpUnit = PumpUnit.fromPumpCurve(
      pumpCurve: PumpCurve(rpm: 3600, points: pumpCurve), frequency: 50.0);

  final newPumpUnit = PumpUnit.fromPumpCurve(
      pumpCurve: PumpCurve(rpm: 3600, points: newPumpCurve), frequency: 50.0);

  setUp(() async {
    await Hive.deleteBoxFromDisk(PumpUnitDb.pumpUnitBoxName);
    Box<PumpUnit> pumpUnitBox =
        await Hive.openBox<PumpUnit>(PumpUnitDb.pumpUnitBoxName);

    await Hive.deleteBoxFromDisk(PumpUnitDb.pumpUnitNamesBoxName);
    Box<String> pumpUnitNamesBox =
        await Hive.openBox<String>(PumpUnitDb.pumpUnitNamesBoxName);
    pumpUnitDb = PumpUnitDb(pumpUnitBox, pumpUnitNamesBox);

    Box<String> _preferencesBox =
        await Hive.openBox<String>(PreferencesDb.boxName);
    preferencesDb = PreferencesDb(_preferencesBox);

    pcl = PowerPumpCurveLogic(source: pumpUnitDb);

    return Future;
  });

  test('setup Min Max gets the pump curve points min and max head', () {
    expect(pcl.powerPUCurves.value.length, 1);
  });

  test('test deletion', () {});
}

void setupHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(PumpCurvePointAdapter())
    ..registerAdapter(MotorAdapter())
    ..registerAdapter(PumpCurveAdapter())
    ..registerAdapter(PumpUnitAdapter());
}

List<PumpCurvePoint> newPumpCurve = [
  PumpCurvePoint.withEfficiency(pumpEndEff: .7, flow: 100, head: 40),
  PumpCurvePoint.withEfficiency(pumpEndEff: .75, flow: 80, head: 60),
  PumpCurvePoint.withEfficiency(pumpEndEff: .8, flow: 60, head: 80),
  PumpCurvePoint.withEfficiency(pumpEndEff: .75, flow: 40, head: 100),
];
