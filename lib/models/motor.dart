import 'dart:collection';

import 'package:variable_speed_pump/utils/constants.dart';

class Motor {
  final double powerkW;
  late final double ratedEfficiency;
  final double frequency;

  Motor(this.powerkW, {this.frequency = 50.0}) {
    this.ratedEfficiency = getAverageMotorEff(powerkW);
  }

  static double getAverageMotorEff(double bkW) {
    return linearInterpolate(bkW, kEfficiencyMotorsFullLoad);
  }

  double getPartialEff(double partialLoad) {
    int indexPower = normalizedMotorsEff
        .indexWhere(((element) => this.powerkW <= element.power));

    if (indexPower <= 0) {
      return ratedEfficiency *
          linearInterpolate(partialLoad, normalizedMotorsEff.first.values);
    } else if (indexPower == normalizedMotorsEff.length - 1) {
      return ratedEfficiency *
          linearInterpolate(partialLoad, normalizedMotorsEff.last.values);
    } else {
      double pA = normalizedMotorsEff[indexPower - 1].power;
      double pB = normalizedMotorsEff[indexPower].power;

      double effA = linearInterpolate(
          partialLoad, normalizedMotorsEff[indexPower - 1].values);
      double effB = linearInterpolate(
          partialLoad, normalizedMotorsEff[indexPower].values);
      return ratedEfficiency *
          (effA + ((effB - effA) * ((powerkW - pA) / (pB - pA))));
    }
  }
}

class NormalizedMotorEff {
  final double power;
  final SplayTreeMap<double, double> values;
  NormalizedMotorEff(this.power, this.values);
}

///Returns a linear interpolated value from a SplayTreeMap. [target] is the value searched
///In the [values] SplayTreeMap the keys represent the range to search
double linearInterpolate(double target, SplayTreeMap<double, double> values) {
  if (values.containsKey(target)) return values[target]!;

  double? xa = values.lastKeyBefore(target);
  double? xb = values.firstKeyAfter(target);

  //very small key
  if (xa != null && xb == null) return values[xa]!;
  //very large key
  if (xa == null && xb != null) return values[xb]!;
  //strange error
  if (xa == null && xb == null)
    throw Exception(
        "number was not found in the SplayTreeMap, check if it is not empty");

  double ya = values[xa] ?? 0;
  double yb = values[xb] ?? 0;

  return ya + ((yb - ya) * ((target - xa!) / (xb! - xa)));
}

// motor efficiency https://en.wikipedia.org/wiki/Premium_efficiency#New_minimum_energy_performance_standards_in_EU
final SplayTreeMap<double, double> kEfficiencyMotorsFullLoad =
    SplayTreeMap<double, double>.from({
  0.75: .825,
  1.1: .841,
  1.5: .853,
  2.2: .867,
  3.0: .877,
  4.0: .886,
  5.5: .896,
  7.5: .904,
  11.0: .914,
  15.0: .921,
  18.5: .926,
  22.0: .930,
  30.0: .936,
  37.0: .939,
  45.0: .942,
  55.0: .946,
  75.0: .950,
  90.0: .952,
  110.0: .954,
  132.0: .956,
  160.0: .958,
  200.0: .960,
});

// Based on: https://bigladdersoftware.com/epx/docs/8-3/engineering-reference/media/motor-normalized-efficiency-vs.-motor-load.png
final List<NormalizedMotorEff> normalizedMotorsEff = [
  NormalizedMotorEff(
    1.0 * kWtoHPFactor,
    SplayTreeMap<double, double>.from({
      .08: .5,
      .12: .6,
      .18: .7,
      .25: .8,
      .45: .9,
      .60: .95,
      .9: 1.0,
    }),
  ),
  NormalizedMotorEff(
    5.0 * kWtoHPFactor,
    SplayTreeMap<double, double>.from({
      .06: .5,
      .08: .6,
      .12: .7,
      .17: .8,
      .28: .9,
      .4: .95,
      .5: 1.0,
    }),
  ),
  NormalizedMotorEff(
    10.0 * kWtoHPFactor,
    SplayTreeMap<double, double>.from({
      .04: .5,
      .06: .6,
      .08: .7,
      .12: .8,
      .20: .9,
      .30: .95,
      .4: 1.0,
    }),
  ),
  NormalizedMotorEff(
    50.0 * kWtoHPFactor,
    SplayTreeMap<double, double>.from({
      .02: .5,
      .04: .6,
      .06: .7,
      .08: .8,
      .15: .9,
      .24: .95,
      .3: 1.0,
    }),
  ),
  NormalizedMotorEff(
    100.0 * kWtoHPFactor,
    SplayTreeMap<double, double>.from({
      .01: .5,
      .02: .6,
      .03: .7,
      .04: .8,
      .08: .9,
      .15: .95,
      .2: 1.0,
    }),
  ),
];
