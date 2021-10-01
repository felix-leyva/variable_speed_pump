import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variable_speed_pump/data_sources/pump_unit_sources.dart';
import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/utils/constants.dart';

Future<void> main() async {
  initHive();

  late Box<PumpUnit> pumpUnitBox;
  late Box<String> pumpUnitNamesBox;

  late PumpUnitSource ps;
  final defaultPumpUnit = PumpUnit.fromPumpCurve(
      pumpCurve: PumpCurve(rpm: 3600, points: pumpCurve), frequency: 50.0);
  final defaultPumpUnitKey = defaultPumpUnit.key;
  final newPumpUnit = PumpUnit.fromPumpCurve(
      pumpCurve: PumpCurve(rpm: 3600, points: newPumpCurve), frequency: 50.0);

  setUp(() async {
    pumpUnitBox = await getAFreshCreatedHiveBox();
    pumpUnitNamesBox = await getAFreshCreatedHiveNamesBox();

    pumpUnitBox.put(defaultPumpUnitKey, defaultPumpUnit);
    pumpUnitNamesBox.put(defaultPumpUnitKey, PumpUnitDb.pumpUnitDefaultName);
    ps = PumpUnitDb(pumpUnitBox, pumpUnitNamesBox);
  });

  test('test initialization is correct and non existent returns an empty curve',
      () {
    var ls = ps.getListOfPumpUnits();
    print(ls);
    expect(ls.keys.elementAt(0), defaultPumpUnitKey);
    var curve = ps.getFirstPumpUnit();
    expect(curve, defaultPumpUnit);
    var nonExistentCurve = ps.getPumpUnitWithKey("non_existing");
    expect(nonExistentCurve, defaultPumpUnit);
  });

  test('put PumpCurve adds a new PU and getPumpCurve returns the correct', () {
    expect(ps.getListOfPumpUnits().length, 1);
    final newPumpKey = 'new_pump_name';
    ps.updateOrAddPumpUnit(newPumpKey, newPumpUnit);
    expect(ps.getListOfPumpUnits().length, 2);
    expect(ps.getPumpUnitWithKey(newPumpKey), newPumpUnit);
    expect(
        ps.getPumpUnitWithKey(newPumpKey).pumpCurve.points[2], newPumpCurve[2]);
  });

  test('modify PumpCurve do not add a new PU', () {
    expect(ps.getListOfPumpUnits().length, 1);
    ps.updateOrAddPumpUnit(defaultPumpUnitKey, newPumpUnit);
    expect(ps.getListOfPumpUnits().length, 1);
    expect(ps.getPumpUnitWithKey(PumpUnitDb.pumpUnitDefaultKey), newPumpUnit);
    expect(
        ps
            .getPumpUnitWithKey(PumpUnitDb.pumpUnitDefaultKey)
            .pumpCurve
            .points[2],
        newPumpUnit.pumpCurve.points[2]);
  });

  test(
      'delete PumpCurve does not removes last one or does not removes if name does not exists',
      () {
    expect(ps.getListOfPumpUnits().length, 1);
    final newPumpName = 'new_pump_name';
    ps.updateOrAddPumpUnit(newPumpName, newPumpUnit);
    expect(ps.getListOfPumpUnits().length, 2);
    ps.deletePumpUnit("false name"); //false name does not deletes
    expect(ps.getListOfPumpUnits().length, 2);
    expect(ps.getListOfPumpUnits().length, 2);
    ps.deletePumpUnit(newPumpName);
    expect(ps.getListOfPumpUnits().length, 1);
    expect(ps.getPumpUnitWithKey(PumpUnitDb.pumpUnitBoxName), defaultPumpUnit);
    ps.deletePumpUnit(defaultPumpCurveName); //last one should not delete
    expect(ps.getListOfPumpUnits().length, 1);
    expect(ps.getPumpUnitWithKey(PumpUnitDb.pumpUnitBoxName), defaultPumpUnit);
  });
}

Future<Box<String>> getAFreshCreatedHiveNamesBox() async {
  //Always starts from a clean box
  await Hive.deleteBoxFromDisk(PumpUnitDb.pumpUnitNamesBoxName);
  return await Hive.openBox<String>(PumpUnitDb.pumpUnitNamesBoxName);
}

void initHive() {
  var path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(PumpCurvePointAdapter())
    ..registerAdapter(MotorAdapter())
    ..registerAdapter(PumpCurveAdapter())
    ..registerAdapter(PumpUnitAdapter());
}

Future<Box<PumpUnit>> getAFreshCreatedHiveBox() async {
  //Always starts from a clean box
  await Hive.deleteBoxFromDisk(PumpUnitDb.pumpUnitBoxName);
  return await Hive.openBox<PumpUnit>(PumpUnitDb.pumpUnitBoxName);
}

List<PumpCurvePoint> newPumpCurve = [
  PumpCurvePoint.withEfficiency(pumpEndEff: .7, flow: 100, head: 40),
  PumpCurvePoint.withEfficiency(pumpEndEff: .75, flow: 80, head: 60),
  PumpCurvePoint.withEfficiency(pumpEndEff: .8, flow: 60, head: 80),
  PumpCurvePoint.withEfficiency(pumpEndEff: .75, flow: 40, head: 100),
];

void main2() {
  // setupHive();

  late PumpUnitSource pumpUnitDb;

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

    return Future;
  });

  test(
      'test creation of PumpUnitDb which should start with 1 if empty, then add 2',
      () {
    expect(pumpUnitDb.getListOfPumpUnits().length, 1);
    String newKey = 'new_key';
    pumpUnitDb.updateOrAddPumpUnit(newKey, newPumpUnit);
    expect(pumpUnitDb.getListOfPumpUnits().length, 2);
  });

  test('test deletion', () {
    expect(pumpUnitDb.getListOfPumpUnits().length, 1);
    String newKey = 'new_key';
    pumpUnitDb.updateOrAddPumpUnit(newKey, newPumpUnit);
    expect(pumpUnitDb.getListOfPumpUnits().length, 2);
    pumpUnitDb.deletePumpUnit(newKey);
    expect(pumpUnitDb.getListOfPumpUnits().length, 1);
  });

  test('test update', () {
    expect(pumpUnitDb.getListOfPumpUnits().length, 1);
    String newKey = 'new_key';
    pumpUnitDb.updateOrAddPumpUnit(newKey, newPumpUnit);
    expect(pumpUnitDb.getListOfPumpUnits().length, 2);
    expect(pumpUnitDb.getPumpUnitWithKey(newKey), newPumpUnit);
    pumpUnitDb.updateOrAddPumpUnit(newKey, defaultPumpUnit);
    expect(pumpUnitDb.getListOfPumpUnits().length, 2);
    expect(pumpUnitDb.getPumpUnitWithKey(newKey), defaultPumpUnit);
  });
}

void setupHive() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(PumpCurvePointAdapter())
    ..registerAdapter(MotorAdapter())
    ..registerAdapter(PumpCurveAdapter())
    ..registerAdapter(PumpUnitAdapter());
}
