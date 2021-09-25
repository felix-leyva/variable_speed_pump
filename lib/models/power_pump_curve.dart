import 'dart:math';

import 'package:variable_speed_pump/models/power_pu_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point.dart';

import 'motor.dart';

class PowerPumpCurve {
  final double head;
  final List<PumpCurvePoint> points;
  PowerPumpCurve({required this.head, required this.points});

  ///Generates a PowerPUCurve selecting automatically the ideal motor power
  ///based on the curve and estimating required power based on partial load
  PowerPUCurve generatePowerPUCurve() {
    final double maxPower = points.map((point) => point.bkW).reduce(max);
    final double powerSegment = kEfficiencyMotorsFullLoad.keys
        .firstWhere((ratedPower) => ratedPower >= maxPower);
    final Motor motor = Motor(powerSegment);
    final List<PumpUnitCurvePoint> pumpUnitCurvePoints = points
        .map((point) => PumpUnitCurvePoint(pumpCurvePoint: point, motor: motor))
        .toList();
    return PowerPUCurve(head: head, motor: motor, points: pumpUnitCurvePoints);
  }
}
