import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/screens/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/utils/constants.dart';

void main() {
  late PowerPumpCurveLogic pcl;

  setUp(() {
    pcl = PowerPumpCurveLogic(pumpCurves: pumpCurve);
  });
  test('setup Min Max gets the pump curve points min and max head', () {
    pcl.setupMinMaxHead();
  });
}