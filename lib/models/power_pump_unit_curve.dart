import 'package:variable_speed_pump/models/motor/motor.dart';
import 'package:variable_speed_pump/models/power_pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point/pump_unit_curve_point.dart';

class PowerPumpUnitCurve {
  final double head;
  late final Motor motor;
  late final List<PumpUnitCurvePoint> powerPumpUnitPoints;

  PowerPumpUnitCurve(
      {required this.head, required this.motor, required this.powerPumpUnitPoints});

  PowerPumpUnitCurve.fromNormalCurvePoints({
    required this.head,
    required List<PumpCurvePoint> normalPumpCurvePoints,
  }) : assert(
            normalPumpCurvePoints.first.rpm == normalPumpCurvePoints.last.rpm) {
    final double rpm = normalPumpCurvePoints.first.rpm;
    final PumpCurve pumpCurve =
        PumpCurve(rpm: rpm, points: normalPumpCurvePoints);
    final PowerPumpCurve powerPumpCurve =
        pumpCurve.powerPumpCurveWithHead(head: head);
    final PowerPumpUnitCurve ppc = powerPumpCurve.generatePowerPUCurve();
    this.motor = ppc.motor;
    this.powerPumpUnitPoints = ppc.powerPumpUnitPoints;
  }
}
