import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';

const double gravity = 9.81;
const double kWtoHPFactor = 0.745699872;

const String pumpCurveBoxName = 'pump_curves_box';
const String defaultPumpCurveName = 'default_pump_curve';

final List<PumpCurvePoint> pumpCurve = [
  PumpCurvePoint.withEfficiency(pumpEndEff: .6, flow: 113.58, head: 60.96),
  PumpCurvePoint.withEfficiency(pumpEndEff: .72, flow: 170.38, head: 59.44),
  PumpCurvePoint.withEfficiency(pumpEndEff: .8, flow: 227.17, head: 57.00),
  PumpCurvePoint.withEfficiency(pumpEndEff: .84, flow: 283.96, head: 54.25),
  PumpCurvePoint.withEfficiency(pumpEndEff: .86, flow: 340.75, head: 50.27),
  PumpCurvePoint.withEfficiency(pumpEndEff: .86, flow: 397.55, head: 45.11),
  PumpCurvePoint.withEfficiency(pumpEndEff: .83, flow: 454.34, head: 38.10),
  PumpCurvePoint.withEfficiency(pumpEndEff: .74, flow: 511.13, head: 30.48),
];
