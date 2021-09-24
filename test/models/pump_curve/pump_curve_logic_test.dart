import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve_logic.dart';
import 'package:variable_speed_pump/utils/constants.dart';

void main() {
  late PumpCurveLogic pcl;

  setUp(() {
    pcl = PumpCurveLogic(pumpCurves: pumpCurve);
  });
  test('setup Min Max gets the pump curve points min and max head', () {
    pcl.setupMinMaxHead();
  });
}
