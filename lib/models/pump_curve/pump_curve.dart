import 'dart:math';

import 'package:equations/equations.dart';
import 'package:hive/hive.dart';
import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';

import '../motor/motor.dart';
import '../power_pump_curve.dart';

part 'pump_curve.g.dart';

///PumpCurve is made of a list of PumpCurvePoints and a fixed RPM to which it operates
@HiveType(typeId: 3)
class PumpCurve {
  @HiveField(0)
  final double rpm;

  @HiveField(1)
  late final List<PumpCurvePoint> points;

  PumpCurve({required this.rpm, required List<PumpCurvePoint> points}) {
    this.points = points..sort((a, b) => a.flow.compareTo(b.flow));
  }

  ///Finds or interpolates the pump curve point based on the head. Uses spline
  ///interpolation.
  PumpCurvePoint? getPointWithHead(double head) {
    final List<PumpCurvePoint> orderedPoints = points;
    orderedPoints.sort((a, b) => a.head.compareTo(b.head));

    if (head < orderedPoints.first.head || head > orderedPoints.last.head)
      return null;

    final List<InterpolationNode> effNodes = orderedPoints
        .map((pcp) => InterpolationNode(x: pcp.head, y: pcp.pumpEndEff))
        .toList();

    final List<InterpolationNode> flowNodes = orderedPoints
        .map((pcp) => InterpolationNode(x: pcp.head, y: pcp.flow))
        .toList();

    final double efficiency =
        SplineInterpolation(nodes: effNodes).compute(head);

    final double flow = SplineInterpolation(nodes: flowNodes).compute(head);

    return PumpCurvePoint.withEfficiency(
        pumpEndEff: efficiency, flow: flow, head: head, rpm: rpm);
  }

  ///Generates a copy of this PumpCurve changing the RPM and with the affinity
  ///law finding each one of the new pump curve points at that lower speed.
  ///[percentage] should be a value between 0 and 1.
  PumpCurve? pumpCurveWithSpeed(double percentage) {
    if (percentage < 0 || percentage > 1) return null;
    List<PumpCurvePoint> newPoints = points
        .map((pcp) => pcp.withLowerSpeed(percentage))
        .toList()
      ..sort((a, b) => a.flow.compareTo(b.flow));
    return PumpCurve(rpm: rpm * percentage, points: newPoints);
  }

  ///Generates a list of new PumpCurves based in the current PumpCurve using the
  ///affinity laws. Default sets 60 steps, to minimum of the half of the current
  ///PumpCurve RPM (usually 3600/2 = 1800 RPM) - turning to 30 RPM steps. Use a
  ///higher amount of steps to increase the resolution of the calculations.
  List<PumpCurve>? pumpCurvesWithSpeedRanges({int steps = 60, double? minRPM}) {
    final double lastRPM = minRPM ?? this.rpm / 2;
    if (steps < 1 || lastRPM > rpm) return null;
    final double minPercentage = (lastRPM / rpm);
    final double step = minPercentage / steps;
    final List<double> range =
        List.generate(steps, (index) => minPercentage + (index * step))
            .reversed
            .toList();
    final List<PumpCurve> pumpCurvesList = [];
    range.forEach((per) {
      var modPumpCurve = pumpCurveWithSpeed(per);
      if (modPumpCurve != null) pumpCurvesList.add(modPumpCurve);
    });
    return pumpCurvesList;
  }

  ///Generates a variable power PumpCurve with a fixed head and the current pump
  ///curve. It generates with affinity law several curves at different speed and
  ///in each of the generated curves interpolates and finds the point where the
  ///head coincides. It chooses thoses points and generate a PowerPumpCurve where
  ///all those points have a fixed head, but variable power/speed.
  PowerPumpCurve powerPumpCurveWithHead({
    int steps = 60,
    double minRPM = 1800,
    required double head,
  }) {
    List<PumpCurve>? pumpCurves =
        pumpCurvesWithSpeedRanges(steps: steps, minRPM: minRPM);
    List<PumpCurvePoint> powerPumpCurvePoints = [];

    pumpCurves!.forEach((pc) {
      final powerPumpPoint = pc.getPointWithHead(head);
      if (powerPumpPoint != null) powerPumpCurvePoints.add(powerPumpPoint);
    });
    powerPumpCurvePoints.sort((a, b) => a.flow.compareTo(b.flow));
    return PowerPumpCurve.fromPointsVariablePower(
        head: head, variablePowerPoints: powerPumpCurvePoints);
  }

  ///Finds out the highest power consumption of this PumpCurve and from a table
  ///of standard motor power ranges it selects the nearest motor which covers
  ///the consumption point.
  double getMotorPowerSegment() {
    final double maxPower = points.map((point) => point.bkW).reduce(max);
    return kEfficiencyMotorsFullLoad.keys
        .firstWhere((ratedPower) => ratedPower >= maxPower);
  }
}
