import 'package:variable_speed_pump/models/motor.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point.dart';

class PowerPUCurve {
  final double head;
  final Motor motor;
  final List<PumpUnitCurvePoint> points;
  PowerPUCurve({required this.head, required this.motor, required this.points});
}
