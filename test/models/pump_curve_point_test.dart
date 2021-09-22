import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/models/pump_curve_point.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

void main() {
  test_whenConstructingWithEff();
  test_whenConstructingWithPower();
  test_whenConstructingWithPower2();
  test_whenChangingSpeed();
}

void test_WHP_WkW_BHP(PumpCurvePoint curvePoint) {
  test("should build and generate WHP correctly", () {
    double wHp = curvePoint.wHp.roundD(2);

    expect(wHp, 25.30);
  });

  test('should generate wKW correctly', () {
    double wkW = curvePoint.wkW.roundD(2);
    expect(wkW, 18.87);
  });

  test('should generate bHP correctly', () {
    double bHP = curvePoint.bHp.roundD(2);
    expect(bHP, 42.17);
  });
}

void test_whenConstructingWithEff() {
  double flow = 113.6;
  double head = 60.95;
  double eff = 0.6;

  PumpCurvePoint curvePoint =
      PumpCurvePoint.withEfficiency(pumpEndEff: eff, head: head, flow: flow);

  test_WHP_WkW_BHP(curvePoint);
}

void test_whenConstructingWithPower() {
  double flow = 113.6;
  double head = 60.95;
  double bHP = 42.17;

  PumpCurvePoint curvePoint =
      PumpCurvePoint.withBHPower(bHp: bHP, head: head, flow: flow);

  test_WHP_WkW_BHP(curvePoint);
  test('should generate eff correctly', () {
    double eff = curvePoint.pumpEndEff.roundD(2);
    expect(eff, 0.6.roundD(2));
  });
}

void test_whenConstructingWithPower2() {
  double flow = 125.3;
  double head = 60;
  double eff = 0.773;

  PumpCurvePoint curvePoint =
      PumpCurvePoint.withEfficiency(pumpEndEff: eff, head: head, flow: flow);

  test('should generate bHP correctly', () {
    double bHP = curvePoint.bHp.roundD(1);
    expect(bHP, (26.44 / .745699872).roundD(1));
  });
}

void test_whenChangingSpeed() {
  double flow = 283.96;
  double head = 54.25;
  double eff = 0.84;

  PumpCurvePoint curvePoint =
      PumpCurvePoint.withEfficiency(pumpEndEff: eff, head: head, flow: flow);

  test('with 59Hz', () {
    double newSpeedPercentage = 59 / 60;
    PumpCurvePoint newCurvePoint =
        curvePoint.withLowerSpeed(newSpeedPercentage);
    expect(newCurvePoint.flow.roundD(2), 279.23);
    expect(newCurvePoint.head.roundD(2), 52.46);
  });

  test('with 45Hz and RPM', () {
    double newSpeedPercentage = 45 / 60;
    double newRPM = curvePoint.rpm * newSpeedPercentage;
    PumpCurvePoint newCurvePoint = curvePoint.withLowerRPM(newRPM);
    expect(newCurvePoint.flow.roundD(2), 212.97);
    expect(newCurvePoint.head.roundD(2), 30.52);
  });
}
