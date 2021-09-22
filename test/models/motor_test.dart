import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/models/motor.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

void main() {
  test_motor_rated_efficiency_based_in_power();
  test_motor_efficiency_on_partial_load();
}

//Tests should be moved to a motor class in case ready, otherwise to an util test
void test_motor_rated_efficiency_based_in_power() {
  test('test that with 5.0 kW motor eff is 89.3%', () {
    double bkW = 5.0;
    Motor motor = Motor(bkW);
    double eff = motor.ratedEfficiency.roundD(3);
    expect(eff, 0.893);
  });

  test('test that with 0.1 kW motor eff is 82.5%', () {
    double bkW = 0.1;
    Motor motor = Motor(bkW);
    double eff = motor.ratedEfficiency..roundD(3);
    expect(eff, 0.825);
  });

  test('test that with 0 kW motor eff is 82.5%', () {
    double bkW = 0.0;
    Motor motor = Motor(bkW);
    double eff = motor.ratedEfficiency..roundD(3);
    expect(eff, 0.825);
  });

  test('test that with 10000 kW motor eff is 96.0%', () {
    double bkW = 10000.0;
    Motor motor = Motor(bkW);
    double eff = motor.ratedEfficiency..roundD(3);
    expect(eff, 0.96);
  });
}

void test_motor_efficiency_on_partial_load() {
  test('test linearInterpolate', () {
    double target = 0.025;
    var values = SplayTreeMap<double, double>.from({
      .01: .5,
      .02: .6,
      .03: .7,
      .04: .8,
      .08: .9,
      .15: .95,
    });

    var result = linearInterpolate(target, values);
    print(result);
    //expect(partialEff, 0.896);
  });

  test('test that with 11.0 kW motor eff at 50% load is 91.4%', () {
    double bkW = 11.0;
    Motor motor = Motor(bkW);
    double partialEff = motor.getPartialEff(.5).roundD(3);
    expect(partialEff, 0.914);
  });

  test('test that with 4.0 kW motor eff at 25% load is 77.7%', () {
    double bkW = 4.0;
    Motor motor = Motor(bkW);
    double partialEff = motor.getPartialEff(.25).roundD(3);
    expect(partialEff, 0.777);
  });

  test('test that with 7.5 kW motor eff at 20% load is 81.4%', () {
    double bkW = 7.5;
    Motor motor = Motor(bkW);
    double partialEff = motor.getPartialEff(.20).roundD(3);
    expect(partialEff, 0.814);
  });
}
