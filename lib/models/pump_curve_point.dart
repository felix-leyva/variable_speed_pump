//Metric values default input

import 'dart:math';

import 'package:hive/hive.dart';
import 'package:variable_speed_pump/utils/constants.dart';

part 'pump_curve_point.g.dart';

@HiveType(typeId: 1)
class PumpCurvePoint {
  PumpCurvePoint();

  ///revolutions per minute
  @HiveField(0)
  double rpm = 3600;

  ///flow in m³/h
  @HiveField(1)
  double flow = 0;

  ///head in m
  @HiveField(2)
  double head = 0;

  ///efficiency of the pump end (eta) 0 to 1.0: wHp/bHp
  @HiveField(3)
  double pumpEndEff = 0;

  ///hydraulic horse power: power generated by the pump end at that hydraulic point
  @HiveField(4)
  double wHp = 0;

  ///brake horse power: required power in the axis of pump end to generate this hydraulic point
  @HiveField(5)
  double bHp = 0;

  ///hydraulic power in kW
  double get wkW => wHp * kWtoHPFactor;

  ///brake power in kW
  double get bkW => bHp * kWtoHPFactor;

  ///kWh used to pump a m3 with the given head and efficiency
  double get kWhrequired => wkW / flow;

  static const double wHPFactorM_M3H = (3600 / gravity) *
      kWtoHPFactor; //time factor sec to hour, gravity, kw to HP factor
  static const double wHPFactorFt_GPM = 3960;

  PumpCurvePoint.withEfficiency(
      {this.rpm = 3600,
      this.flow = 0,
      this.head = 0,
      required this.pumpEndEff}) {
    this.wHp = _wHp();
    this.bHp = wHp / pumpEndEff;
  }

  PumpCurvePoint.withBHPower(
      {this.rpm = 3600, this.flow = 0, this.head = 0, this.bHp = 0}) {
    this.wHp = _wHp();
    this.pumpEndEff = wHp / bHp;
  }

  static double estimateWhp(double flow, double head) =>
      flow * head / wHPFactorM_M3H;
  double _wHp() => flow * head / wHPFactorM_M3H;

  PumpCurvePoint withLowerSpeed(double percentage) {
    //Uses the affinity laws to estimate a new lower speed point
    if (percentage < 0)
      return this; //if percentage is negative, should return a copy of the current unmodified
    double newFlow = this.flow * percentage;
    double newHead = this.head * pow(percentage, 2);
    double rpm = this.rpm * percentage;

    return PumpCurvePoint.withEfficiency(
        pumpEndEff: this.pumpEndEff, flow: newFlow, head: newHead, rpm: rpm);
  }

  PumpCurvePoint withLowerRPM(double rpm) {
    double percentage = rpm / this.rpm;
    return this.withLowerSpeed(percentage);
  }
}

class PowerSpeed {
  double power;
  double speed;
  PowerSpeed(this.power, this.speed);
}
