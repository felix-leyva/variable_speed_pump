import 'dart:math';

import 'package:equations/equations.dart';
import 'package:variable_speed_pump/models/pump_curve_point.dart';

import 'PowerPumpCurve.dart';

class PumpCurve {
  final double rpm;
  late final List<PumpCurvePoint> points;

  PumpCurve({required this.rpm, required List<PumpCurvePoint> points}) {
    this.points = points..sort((a, b) => a.flow.compareTo(b.flow));
  }

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

  PumpCurve? pumpCurveWithSpeed(double percentage) {
    if (percentage < 0 || percentage > 1) return null;
    List<PumpCurvePoint> newPoints =
        points.map((pcp) => pcp.withLowerSpeed(percentage)).toList();
    return PumpCurve(rpm: rpm * percentage, points: newPoints);
  }

  List<PumpCurve>? pumpCurvesWithSpeedRanges(
      {int steps = 60, double minRPM = 1800}) {
    if (steps < 1 || minRPM > rpm) return null;
    final double minPercentage = (minRPM / rpm);
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
    return PowerPumpCurve(head: head, points: powerPumpCurvePoints);
  }
}

//Functions during development - only used currently in tests
List<PowerSpeed> getSpeedAndPower(
    int speed, double pMax, double pMin, int steps) {
  double step = (pMax - pMin) / steps;
  List<double> powerSteps =
      List.generate(steps, (index) => pMin + (index + 1) * step);

  return powerSteps
      .map((e) => PowerSpeed(e, speed * pow(e / steps, 1 / 3).toDouble()))
      .toList();
}

List<PowerAndPercentage> getPowerAndPercent(double pMax, int steps) {
  double step = (pMax) / steps;
  List<double> powerSteps = List.generate(steps, (index) => (index + 1) * step);

  return powerSteps
      .map((e) => PowerAndPercentage(e, pow(e / pMax, 1 / 3).toDouble()))
      .toList();
}

class PowerAndPercentage {
  double power;
  double percentage;
  PowerAndPercentage(this.power, this.percentage);
}
