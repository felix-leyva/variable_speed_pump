import 'dart:core';

import 'package:variable_speed_pump/models/pump_curve_points/pump_curve_point.dart';
import 'package:variable_speed_pump/utils/constants.dart';

import '../motor/motor.dart';

///PumpUnitCurvePoint is a PumpCurvePoint which implements the effects of having
///a motor, so it can make the calculations of required power based on that
///motor efficiency.
class PumpUnitCurvePoint {
  late PumpCurvePoint pumpCurvePoint;
  late Motor motor;
  double get motorkW => motor.powerkW;
  double get motorHP => motorkW / kWtoHPFactor;
  double get motorPartialEff =>
      motor.getPartialEff(pumpCurvePoint.bkW / motorkW);
  double get requiredkW => pumpCurvePoint.bkW / motorPartialEff;
  double get efficiency => pumpCurvePoint.wkW / requiredkW;

  PumpUnitCurvePoint({required this.pumpCurvePoint, required this.motor});

  //These constructors are not being used yet, due that the PowerPumpUnitCurve
  //is generated on the go

  ///Constructor which requires the PumpEnd efficiency and estimates motor
  ///efficiency and power based in IE3 standard
  PumpUnitCurvePoint.withPEEff({
    required double flow,
    required double head,
    required double pumpEndEff,
    required double motorPower,
  }) {
    this.pumpCurvePoint = PumpCurvePoint.withEfficiency(
      pumpEndEff: pumpEndEff,
      head: head,
      flow: flow,
    );

    if (motorPower > 0) {
      this.motor = Motor(motorPower);
    } else {
      this.motor = Motor(0.5);
    }
  }

  PumpUnitCurvePoint.withPowers({
    required double flow,
    required double head,
    required double motorkW,
    double pumpEndBKw = 0,
  }) {
    this.motor = Motor(motorkW);
    var motorEff = motor.ratedEfficiency;

    double bHp;
    if (pumpEndBKw != 0) {
      bHp = pumpEndBKw / kWtoHPFactor;
    } else {
      bHp = (motorkW / motorEff) / kWtoHPFactor;
    }

    this.pumpCurvePoint = PumpCurvePoint.withBHPower(
      bHp: bHp,
      head: head,
      flow: flow,
    );
  }

  PumpUnitCurvePoint.withPUEff({
    required double flow,
    required double head,
    required double pumpUnitEff,
  }) {
    //get water kW
    double wkW = PumpCurvePoint.estimateWhp(flow, head) * kWtoHPFactor;

    //first pass to get a hypothetic starting motor efficiency
    double hypotheticalPEEff = 0.7;
    double hypotheticalBkW = wkW * hypotheticalPEEff;
    double hypotheticalMotorEff = Motor.getAverageMotorEff(hypotheticalBkW);

    double pumpEndEff = pumpUnitEff / hypotheticalMotorEff;
    this.pumpCurvePoint = PumpCurvePoint.withEfficiency(
      pumpEndEff: pumpEndEff,
      head: head,
      flow: flow,
    );
    double motorEff = Motor.getAverageMotorEff(pumpCurvePoint.bkW);
    double motorPower = this.pumpCurvePoint.bHp / motorEff;
    this.motor = Motor(motorPower);
  }

  //TODO with only pumpCurvePoint - estimating motor Eff
}
