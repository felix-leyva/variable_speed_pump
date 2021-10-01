import 'package:variable_speed_pump/models/power_pump_unit_curve.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point/pump_unit_curve_point.dart';

import 'motor/motor.dart';

class PowerPumpCurve {
  final double head;
  List<PumpCurvePoint> get points => this.powerPumpCurvePoints.points;
  late final PumpCurve powerPumpCurvePoints;

  PowerPumpCurve.fromPointsVariablePower(
      {required this.head,
      required List<PumpCurvePoint> variablePowerPoints,
      double? rpm}) {
    double pumpRPM = rpm ?? 3600.0;
    this.powerPumpCurvePoints =
        PumpCurve(rpm: pumpRPM, points: variablePowerPoints);
  }

  ///Generates a PowerPUCurve selecting automatically the ideal motor power
  ///based on the curve and estimating required power based on partial load
  PowerPumpUnitCurve generatePowerPUCurve() {
    final double powerSegment = powerPumpCurvePoints.getMotorPowerSegment();
    final Motor motor = Motor(powerSegment);
    final List<PumpUnitCurvePoint> pumpUnitCurvePoints = points
        .map((point) => PumpUnitCurvePoint(pumpCurvePoint: point, motor: motor))
        .toList();
    return PowerPumpUnitCurve(
        head: head, motor: motor, powerPumpUnitPoints: pumpUnitCurvePoints);
  }
}
