import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/models/motor.dart';
import 'package:variable_speed_pump/models/pump_curve_point.dart';
import 'package:variable_speed_pump/models/pump_unit_curve_point.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

void main() {
  test_constructing_withPumpEndEfficiency();
}

//Tests should be moved to a motor class in case ready, otherwise to an util test

void test_constructing_withPumpEndEfficiency() {
  group('unit Test on PumpUnitCurveConstructors', () {
    var pumpEndEff;
    var head;
    var flow;
    var motorPower;
    var bHp;

    setUp(() {
      pumpEndEff = 0.6;
      head = 60.96;
      flow = 113.6;
      motorPower = 50.0;
      bHp = 42.17;
    });

    test('test the withPEEff', () {
      PumpCurvePoint pumpCurvePoint = PumpCurvePoint.withEfficiency(
          pumpEndEff: pumpEndEff, head: head, flow: flow);
      Motor motor = Motor(motorPower);

      PumpUnitCurvePoint pumpUnitCurvePoint =
          PumpUnitCurvePoint(pumpCurvePoint: pumpCurvePoint, motor: motor);

      expect(pumpUnitCurvePoint.motorkW, motorPower);
      expect(pumpUnitCurvePoint.pumpCurvePoint.flow, flow);
      expect(pumpUnitCurvePoint.pumpCurvePoint.head, head);
      expect(pumpUnitCurvePoint.pumpCurvePoint.pumpEndEff, pumpEndEff);
    });

    test('test the withPEEff', () {
      PumpCurvePoint pumpCurvePoint =
          PumpCurvePoint.withBHPower(bHp: bHp, head: head, flow: flow);
      Motor motor = Motor(motorPower);

      PumpUnitCurvePoint pumpUnitCurvePoint =
          PumpUnitCurvePoint(pumpCurvePoint: pumpCurvePoint, motor: motor);

      expect(pumpUnitCurvePoint.motorkW.roundD(2), motorPower);
      expect(pumpUnitCurvePoint.pumpCurvePoint.flow.roundD(2), flow);
      expect(pumpUnitCurvePoint.pumpCurvePoint.head.roundD(2), head);
      expect(
          pumpUnitCurvePoint.pumpCurvePoint.pumpEndEff.roundD(2), pumpEndEff);
    });
  });
}
