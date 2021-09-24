import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:variable_speed_pump/models/data_sources/pump_curves_sources.dart';
import 'package:variable_speed_pump/models/pump_curve_point.dart';
import 'package:variable_speed_pump/utils/constants.dart';

Future<void> main() async {
  initHive();

  late Box<List<PumpCurvePoint>> pumpCurvesBox;

  late PumpCurvesSources ps;

  setUp(() async {
    pumpCurvesBox = await getAFreshCreatedHiveBox();
    pumpCurvesBox.put(defaultPumpCurveName, pumpCurve);
    ps = PumpCurvesDB(pumpCurvesBox);
  });

  test('test initialization is correct and non existent returns an empty curve',
      () {
    var ls = ps.getListOfPumpCurves();
    expect(ls[0], defaultPumpCurveName);
    var curve = ps.getPumpCurves(null);
    expect(curve, pumpCurve);
    var nonExistentCurve = ps.getPumpCurves("non_existing");
    var emptyList =
        List.generate(0, (index) => PumpCurvePoint()).cast<PumpCurvePoint>();
    expect(nonExistentCurve, emptyList);
  });

  test('put PumpCurve adds a new PU and getPumpCurve returns the correct', () {
    expect(ps.getListOfPumpCurves().length, 1);
    final newPumpName = 'new_pump_name';
    ps.putPumpCurve(newPumpName, newPumpCurve);
    expect(ps.getListOfPumpCurves().length, 2);
    expect(ps.getPumpCurves(newPumpName), newPumpCurve);
    expect(ps.getPumpCurves(newPumpName)[2], newPumpCurve[2]);
  });

  test('modify PumpCurve do not add a new PU', () {
    expect(ps.getListOfPumpCurves().length, 1);
    ps.putPumpCurve(defaultPumpCurveName, newPumpCurve);
    expect(ps.getListOfPumpCurves().length, 1);
    expect(ps.getPumpCurves(defaultPumpCurveName), newPumpCurve);
    expect(ps.getPumpCurves(defaultPumpCurveName)[2], newPumpCurve[2]);
  });

  test(
      'delete PumpCurve does not removes last one or does not removes if name does not exists',
      () {
    expect(ps.getListOfPumpCurves().length, 1);
    final newPumpName = 'new_pump_name';
    ps.putPumpCurve(newPumpName, newPumpCurve);
    expect(ps.getListOfPumpCurves().length, 2);
    ps.deletePumpCurve("false name"); //false name does not deletes
    expect(ps.getListOfPumpCurves().length, 2);
    ps.deletePumpCurve(newPumpName);
    expect(ps.getListOfPumpCurves().length, 1);
    expect(ps.getPumpCurves(defaultPumpCurveName), pumpCurve);
    ps.deletePumpCurve(defaultPumpCurveName); //last one should not delete
    expect(ps.getListOfPumpCurves().length, 1);
    expect(ps.getPumpCurves(defaultPumpCurveName), pumpCurve);
  });
}

void initHive() {
  var path = Directory.current.path;
  Hive
    ..init(path)
    ..registerAdapter(PumpCurvePointAdapter());
}

Future<Box<List<PumpCurvePoint>>> getAFreshCreatedHiveBox() async {
  //Always starts from a clean box
  await Hive.deleteBoxFromDisk(pumpCurveBoxName);
  return await Hive.openBox<List<PumpCurvePoint>>(pumpCurveBoxName);
}

List<PumpCurvePoint> newPumpCurve = [
  PumpCurvePoint.withEfficiency(pumpEndEff: .7, flow: 100, head: 40),
  PumpCurvePoint.withEfficiency(pumpEndEff: .75, flow: 80, head: 60),
  PumpCurvePoint.withEfficiency(pumpEndEff: .8, flow: 60, head: 80),
  PumpCurvePoint.withEfficiency(pumpEndEff: .75, flow: 40, head: 100),
];
