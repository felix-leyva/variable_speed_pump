import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/models/power_pu_curve.dart';
import 'package:variable_speed_pump/models/power_pump_curve.dart';
import 'package:variable_speed_pump/models/pump_curve.dart';
import 'package:variable_speed_pump/utils/constants.dart';
import 'package:variable_speed_pump/utils/math_functions.dart';

void main() {
  double head = 30.0;
  PumpCurve pc = PumpCurve(rpm: 3600, points: pumpCurve);
  PowerPumpCurve ppc = pc.powerPumpCurveWithHead(head: head);
  PowerPUCurve powerPUCurve = ppc.generatePowerPUCurve();

  test(
      'power pump unit curve was built correctly with same head,'
      ' points and head', () {
    expect(powerPUCurve.head, head);
    expect(powerPUCurve.points.length, ppc.points.length);
  });

  powerPUCurve.points.map((e) => e).forEach((element) {
    test('test with point ${element.pumpCurvePoint.flow}', () {
      expect(element.pumpCurvePoint.head, head);
      expect(
        element.efficiency.roundD(4),
        (element.motorPartialEff * element.pumpCurvePoint.pumpEndEff).roundD(4),
      );
      // print(
      //     '${element.requiredkW} : ${element.pumpCurvePoint.flow} : eff: ${element.efficiency}');
    });
  });
}
