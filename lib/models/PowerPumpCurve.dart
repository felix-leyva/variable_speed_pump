import 'package:variable_speed_pump/models/pump_curve_point.dart';

class PowerPumpCurve {
  final double head;
  final List<PumpCurvePoint> points;
  PowerPumpCurve({required this.head, required this.points});
}
