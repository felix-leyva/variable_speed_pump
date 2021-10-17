import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit/pump_unit.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point/pump_unit_curve_point.dart';

import 'pump_curve_point_input.dart';

List<List<PumpCurvePointInput>> speedPumpCurvePointInputListFromPumpUnit(
        List<PumpCurve> pumpCurves) =>
    pumpCurves
        .map((pumpCurve) =>
            pumpCurve.points.map(pointInputFromCurveEff).toList())
        .toList();

List<PumpCurvePointInput> powerPumpCurvePointInputListFromPumpUnit(
    {required PumpUnit pumpUnit, required bool useEfficiency}) {
  List<PumpCurvePointInput> pumpCurveInput;

  if (useEfficiency) {
    pumpCurveInput =
        pumpUnit.pumpCurve.points.map(pointInputFromCurveEff).toList();
  } else {
    pumpCurveInput = pumpUnit.pumpCurve.points
        .map((point) => pointInputFromCurvePower(point, pumpUnit))
        .toList();
  }
  return pumpCurveInput;
}

PumpCurvePointInput pointInputFromCurvePower(
    PumpCurvePoint point, PumpUnit pumpUnit) {
  final pumpCurvePoint =
      PumpUnitCurvePoint(pumpCurvePoint: point, motor: pumpUnit.motor);

  return PumpCurvePointInput(
      flow: point.flow,
      head: point.head,
      efficiencyOrPower: pumpCurvePoint.requiredkW);
}

PumpCurvePointInput pointInputFromCurveEff(PumpCurvePoint point) =>
    PumpCurvePointInput(
        flow: point.flow,
        head: point.head,
        efficiencyOrPower: point.pumpEndEff * 100);

PumpUnit pumpUnitFromEffCurvePoints(
    {required List<PumpCurvePointInput> pumpCurvePoints,
    required PumpUnit pumpUnit}) {
  final double rpm = 3600;
  final points = pumpCurvePoints
      .map((point) => PumpCurvePoint.withEfficiency(
            rpm: rpm,
            pumpEndEff: point.efficiencyOrPower / 100,
            head: point.head,
            flow: point.flow,
          ))
      .toList();

//Obtain motor, RPM, Hz - create a PU
  final pumpCurve = PumpCurve(
    rpm: rpm,
    points: points,
  );

  final motor = Motor(pumpCurve.getMotorPowerSegment());
  return pumpUnit.copyWith(pumpCurve: pumpCurve, motor: motor);
}
