import 'package:hive/hive.dart';
import 'package:nanoid/nanoid.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point/pump_unit_curve_point.dart';

import '../motor/motor.dart';

part 'pump_unit.g.dart';

@HiveType(typeId: 4)
class PumpUnit {
  @HiveField(0)
  late Motor motor;

  @HiveField(1)
  PumpCurve pumpCurve;

  @HiveField(2)
  String name = DateTime.now().millisecondsSinceEpoch.toString();

  @HiveField(3)
  String key = nanoid(10);

  List<PumpCurvePoint> get pumpCurvePoints => this.pumpCurve.points;

  List<PumpUnitCurvePoint> get pumpUnitCurvePoints => this
      .pumpCurve
      .points
      .map((pcp) => PumpUnitCurvePoint(pumpCurvePoint: pcp, motor: motor))
      .toList();

  PumpUnit(
      {required this.motor,
      required this.pumpCurve,
      String? pumpUnitName,
      String? startKey}) {
    this.key = startKey ?? nanoid(10);
    this.name = pumpUnitName ??
        DateTime.fromMillisecondsSinceEpoch(0).toIso8601String();
  }

  PumpUnit.fromPumpCurve(
      {required this.pumpCurve, double? frequency, String? name}) {
    if (name != null) this.name = name;
    final double motorFrequency = frequency ?? 60.0;
    double requiredMotorkW = pumpCurve.getMotorPowerSegment();
    this.motor = Motor(requiredMotorkW, frequency: motorFrequency);
  }

  PumpUnit copyWith({
    Motor? motor,
    PumpCurve? pumpCurve,
    String? name,
    String? key,
    double? motorFrequency,
    double? requiredMotorkW,
  }) {
    return PumpUnit(
      motor: motor ?? this.motor,
      pumpCurve: pumpCurve ?? this.pumpCurve,
      pumpUnitName: name ?? this.name,
      startKey: key ?? this.key,
    );
  }
}
